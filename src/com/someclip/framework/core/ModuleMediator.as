package components.managers
{
	import com.someclip.framework.core.SystemConst;
	import com.someclip.framework.interfaces.IBaseView;
	import com.someclip.framework.interfaces.IMediator;
	import com.someclip.framework.interfaces.INotification;
	import com.someclip.framework.interfaces.IProxy;
	import com.someclip.framework.pattern.Facade;
	import com.someclip.framework.pattern.Mediator;
	import com.someclip.utils.cache.CacheManager;
	import com.someclip.utils.load.LoadManager;
	import com.someclip.utils.load.LoadType;
	import com.someclip.utils.queue.IQueue;
	import com.someclip.utils.queue.IQueueItem;
	import com.someclip.utils.queue.Queue;
	import com.someclip.utils.queue.QueueItem;

	import consts.CacheConst;
	import consts.GameConst;
	import utils.ObjectTool;

	import flash.display.DisplayObject;
	import flash.display.Stage;

	import vo.ViewConfigVO;

	/**
	 * 模块管理类，加载，创建。缓存等逻辑
	 * @author Argus
	 *
	 */
	public class ModuleMediator extends Mediator implements IMediator
	{
		private var _currentViewName:String;
		private var _currentViewParam:Object;
		private var _currentViewConfigVO:ViewConfigVO;
		private var _creating:Boolean=false;
		private var _queue:Array;
		public var rootHolder:Stage;

		public function ModuleMediator()
		{
			this.notifyAcceptable=true;
			_queue=new Array();
		}

		override public function listInterested():Array
		{
			return [SystemConst.CREATE_VIEW];
		}

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.name)
			{
				case SystemConst.CREATE_VIEW:
					createViewHandler(notification.body);
					break;
			}
		}

		private function createViewHandler(body:Object):void
		{
			if (_creating == false)
			{
				_queue.push(body);
				createView(body.name, body.param);
			}
			else
			{
				_queue.push(body);
			}
		}

		override public function createView(viewName:String, params:Object=null):void
		{
			_creating=true;
			var viewIns:IBaseView=CacheManager.instance.pick(viewName) as IBaseView;
			if (viewIns == null)
			{
				makeView(viewName, params);
			}
			else
			{
				showView(viewIns, params, viewName);
			}
		}

		private function showView(viewIns:IBaseView, params:Object, viewName:String):void
		{
			createViewSucc(viewName, viewIns, params);
		}

		private function createViewSucc(viewName:String, viewIns:IBaseView, params:Object):void
		{
			trace("成功创建：", viewName, "模块");
			_queue.shift();
			if (_queue.length > 0)
			{

				createView(_queue[0].name, _queue[0].params);
			}
			else
			{
				_creating=false;
			}
			viewIns.visible=false;
			if (_currentViewConfigVO.depth != -1)
			{
				rootHolder.addChildAt(viewIns as DisplayObject, _currentViewConfigVO.depth);
			}
			else
			{
				rootHolder.addChild(viewIns as DisplayObject);
			}
			viewIns.init(params);
			Facade.instance.retrieveMediator(viewIns.viewName.replace("View", "Mediator")).notifyAcceptable=true;
			viewIns.display();
			sendNotification(SystemConst.VIEW_CREATED, viewName);

		}

		private function makeView(viewName:String, params:Object):void
		{
			_currentViewName=viewName;
			_currentViewParam=params;
			var configList:Array=CacheManager.instance.pick(CacheConst.VIEW_CONFIG_LIST) as Array;
			var configVO:ViewConfigVO=ObjectTool.getObjectByName("viewName", _currentViewName, configList) as ViewConfigVO;
			if (configVO == null)
			{
				createViewFail();
				trace("无法创建未定义的模块:", _currentViewName);
				return;
			}
			_currentViewConfigVO=configVO;
			//加载所需资源
			var queue:Queue=new Queue();
			queue.queueTitle="资源";
			queue.showProgress=true;
			queue.completeHandler=resoureLoadedHandler;
			var queueItem:QueueItem=new QueueItem();
			queueItem.itemName="";
			queueItem.itemType=LoadType.CONTENT;
			//TODO 正式版要把后面的随机去掉。。。。。
			queueItem.itemURL=configVO.packageName.replace(/\./g, "\/") + "/" + configVO.viewName + "Module.swf" + "?" + Math.random();
			trace("资源路径：", queueItem.itemURL);
			queueItem.completeHandler=moduleLoadedHandler;
			queue.addSub(queueItem);
			LoadManager.instance.load(queue);
		}

		private function createViewFail():void
		{
			_queue.shift();
			_creating=false;
			if (_queue.length > 0)
			{
				createView(_queue[0].name, _queue[0].params);
			}
		}

		private function moduleLoadedHandler(queueItem:IQueueItem):void
		{
			if (queueItem.done != 1)
			{
				trace("※", queueItem.itemURL, "无法到达!");
				createViewFail();
				return;
			}
			var viewIns:IBaseView;
			var mediatorIns:IMediator;
			try
			{
				var viewCls:Class=queueItem.applicationDomain.getDefinition(_currentViewConfigVO.packageName + "." + _currentViewName + "View") as Class;
				viewIns=new viewCls();
			}
			catch (e:Error)
			{
				trace(_currentViewConfigVO.packageName + "." + _currentViewName + "View" + "Not FOUND");
			}
			if (viewIns == null)
				return;
			try
			{
				var mediatorCls:Class=queueItem.applicationDomain.getDefinition(_currentViewConfigVO.packageName + "." + _currentViewName + "Mediator") as Class;
				mediatorIns=new mediatorCls();
			}
			catch (e:Error)
			{
				trace(_currentViewName + "Mediator " + "Not FOUND");
			}
			if (mediatorIns)
			{
				mediatorIns.viewComponent=viewIns;
				Facade.instance.registerMediator(mediatorIns);
			}
			try
			{
				var proxyCls:Class=queueItem.applicationDomain.getDefinition(_currentViewConfigVO.packageName + "." + _currentViewName + "Proxy") as Class;
				var proxy:IProxy=new proxyCls();
			}
			catch (e:Error)
			{
			}
			if (proxy)
			{
				proxy.viewComponent=viewIns;
				Facade.instance.registerProxy(proxy);
			}
			CacheManager.instance.store(_currentViewName, viewIns, CacheManager.STORE_UNTIL_REMOVE, queueItem.applicationDomain);
			createViewSucc(_currentViewName, viewIns, _currentViewParam);
		}

		private function resoureLoadedHandler(queue:IQueue):void
		{

		}
	}
}
