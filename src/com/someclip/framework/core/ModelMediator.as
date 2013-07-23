package components.managers
{
	import com.adobe.serialization.json.JSON;
	import com.someclip.framework.core.SystemConst;
	import com.someclip.framework.interfaces.IMediator;
	import com.someclip.framework.interfaces.INotification;
	import com.someclip.framework.interfaces.IProxy;
	import com.someclip.framework.pattern.Facade;
	import com.someclip.framework.pattern.Mediator;
	import com.someclip.utils.cache.CacheManager;
	import com.someclip.utils.load.DataLoader;
	import com.someclip.utils.load.LoadType;
	import com.someclip.utils.queue.IQueueItem;
	import com.someclip.utils.queue.QueueItem;

	import consts.CacheConst;
	import consts.NotifyConst;

	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import utils.ObjectTool;

	import vo.RequestConfigVO;

	/**
	 * 通讯逻辑管理类
	 * @author Argus
	 *
	 */
	public class ModelMediator extends Mediator implements IMediator
	{
		private var requestList:Array;
		private var requests:Array;
		private var _tid:int;

		public function ModelMediator()
		{
			this.notifyAcceptable=true;
		}

		override public function onRegister():void
		{
			requests=new Array();
		}

		override public function listInterested():Array
		{
			return [SystemConst.SEND_REQUEST];
		}

		override public function handleNotification(notification:INotification):void
		{
			switch (notification.name)
			{
				case SystemConst.SEND_REQUEST:
					sendRequestToServer(notification.body);
					break;
			}
		}

		private function sendRequestToServer(body:Object):void
		{
			if (requestList == null)
			{
				requestList=CacheManager.instance.pick(CacheConst.REQUEST_CONGIF_LIST) as Array;
			}
			if (requestList == null || requestList.length < 1)
			{
				throw new Error("通讯接口未定义，无法发起请求！");
			}
			var requestConfig:RequestConfigVO=ObjectTool.getObjectByName("key", body.cmd, requestList) as RequestConfigVO;
			if (requestConfig == null)
			{
				trace("接口:", body.cmd, "未定义，无法发起请求!");
			}
			var queueItem:IQueueItem=new QueueItem();
			queueItem.completeHandler=requestHandler;
			queueItem.itemType=LoadType.DATA;
			queueItem.itemVars=body.vars;
			if (queueItem.itemVars == null)
			{
				queueItem.itemVars=new Object();
			}
			if (queueItem.itemVars.method == null)
			{
				if (body.method != null)
				{
					queueItem.itemVars.method=body.mothod;
				}
				else
				{
					queueItem.itemVars.method=URLRequestMethod.GET;
				}

			}

			queueItem.itemURL=requestConfig.url;
			queueItem.itemName=queueItem.itemURL;
			var loader:DataLoader=new DataLoader();
			loader.startLoad(queueItem);
			clearTimeout(_tid);
			_tid=setTimeout(showLoading, 500);
			requests[queueItem.itemName]={proxy: loader, requester: body.requester, cmd: body.cmd, vars: body.vars};
			loader=null;
			queueItem=null;
		}

		private function showLoading():void
		{
			clearTimeout(_tid);
			sendNotification(NotifyConst.REQUIRE_REQEUST_LOADING);
		}

		override public function sendRequest(requestCMD:String, requestVars:Object=null, requestMethod:String=""):void
		{

		}

		private function requestHandler(queueItem:IQueueItem):void
		{
			clearTimeout(_tid);
			sendNotification(NotifyConst.HIDE_LOADING);
			requests[queueItem.itemName].proxy=null;
			delete requests[queueItem.itemName].proxy;
			var cmd:String=requests[queueItem.itemName].cmd;
			var data:Object=CacheManager.instance.pick(queueItem.cacheKey);
			var name:String=requests[queueItem.itemName].requester;
			if (queueItem.done == -1)
			{
				trace("※", name, "发起的" + cmd + "请求失败:接口无法到达！");
				delete requests[queueItem.itemName].cmd;
				delete requests[queueItem.itemName].requester;
				delete requests[queueItem.itemName];
				name=null;
				cmd=null;
				data=null;
				proxy=null;
				queueItem=null;
				return;
			}
			else if (queueItem.done == -2)
			{
				trace("※", name, "发起的" + cmd + "请求失败:沙箱错误！");
				delete requests[queueItem.itemName].cmd;
				delete requests[queueItem.itemName].requester;
				delete requests[queueItem.itemName];
				name=null;
				cmd=null;
				data=null;
				proxy=null;
				queueItem=null;
				return;
			}
			else if (queueItem.done == 1)
			{
				trace("※", name, "发起的" + cmd + "请求成功返回:", data);
			}
			if (data != null)
			{
				try
				{
					data=JSON.decode(data as String) as Object;
				}
				catch (e:Error)
				{
					trace(e);
					return;
				}
			}
			name=name.replace("Mediator", "Proxy");
			var proxy:IProxy=Facade.instance.retriveProxy(name);
			if (proxy)
			{
				data.requestVars=requests[queueItem.itemName].vars;
				proxy.handleData(cmd, data);
			}
			delete requests[queueItem.itemName].cmd;
			delete requests[queueItem.itemName].requester;
			delete requests[queueItem.itemName].vars;
			delete requests[queueItem.itemName];
			name=null;
			cmd=null;
			data=null;
			proxy=null;
			queueItem=null;
		}
	}
}
