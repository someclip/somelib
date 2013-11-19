package com.someclip.utils.load
{
	import com.someclip.framework.core.SystemConst;
	import com.someclip.framework.pattern.Facade;
	import com.someclip.utils.queue.IQueue;
	import com.someclip.utils.queue.IQueueItem;
	import com.someclip.utils.queue.Queue;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.getTimer;

	public class LoadManager extends EventDispatcher
	{
		private static var _instance:LoadManager;
		public static const SHOW_PROGRESS:String="show_progress";
		public static const HIDE_PROGRESS:String="hide_progress";
		private var _queue:Array;
		private var _isLoading:Boolean;
		private var _currentLoader:ILoader;
		private var _dataLoader:DataLoader;
		private var _contentLoader:ContentLoader;
		private var _handler:Function;

		public function LoadManager()
		{
			if (_instance)
				throw new Error("LoadManager是单例，LoadManager.instance获取实例!!!");
			_queue=new Array();
			_isLoading=false;
			_dataLoader=new DataLoader();
			_dataLoader.boardcastor.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_contentLoader=new ContentLoader();
			_contentLoader.boardcastor.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		}

		public static function get instance():LoadManager
		{
			if (!_instance)
				_instance=new LoadManager();
			return _instance;
		}

		/**
		 * 加载一个队列
		 * 队列内包含组成队列的有序元素，加载会按队列顺序一直加载到最后一个元素为止，不管发生什么错误都会直接进行后续加载。
		 * 加载完成的回调请参考Queue类。
		 * @see com.someclip.utils.queue.Queue;
		 * @see com.someclip.utils.queue.IQueue;
		 * @see com.someclip.utils.queue.QueueItem;
		 * @see com.someclip.utils.queue.IQueueItem;
		 * @param queue 队列
		 *
		 */
		public function load(queue:IQueue):void
		{
			_queue.push(queue);
			if (!_isLoading)
			{
				doLoad();
			}
		}

		/**
		 * 插入进度处理函数，进度条用!
		 * @param handler
		 *
		 */
		public function insertProgressHandler(handler:Function):void
		{
			_handler=handler;
		}

		/**
		 * 移除进度处理函数，进度条用！
		 *
		 */
		public function removeProgressHandler():void
		{
			_handler=null;
		}

		private function progressHandler(e:ProgressEvent):void
		{
			if (_handler != null)
			{
				_handler((_queue[0] as Queue).queueTitle, (_queue[0] as Queue).itemTitle, e);
			}
		}

		private function doLoad():void
		{
			_isLoading=true;
			if (_queue.length > 0)
			{
				if ((_queue[0] as IQueue).showProgress)
				{
					//发出消息显示progressbar
					Facade.instance.sendNotification(SystemConst.REQUIRE_PROGRESS);
				}
				startLoad();
			}
			else
			{
				_isLoading=false;
			}
		}

		private function startLoad():void
		{
			var queue:IQueue=_queue[0] as IQueue;
			var queueItem:IQueueItem=queue.getNext();
			if (queueItem && queueItem.done == 0)
			{
				loadSub(queueItem);
			}
			else
			{
				if (queue.showProgress)
				{
					removeProgressHandler();
					Facade.instance.sendNotification(SystemConst.HIDE_PROGRESS);
				}
				if (queue.completeHandler != null)
				{
					queue.completeHandler(queue);
				}
				_queue.shift();
				doLoad();
			}
		}

		private function loadSub(sub:IQueueItem):void
		{
			switch (sub.itemType)
			{
				case LoadType.DATA:
					_currentLoader=_dataLoader;
//					_currentLoader=new DataLoader();
					break;
				case LoadType.DATA_VARS:
					_currentLoader=_dataLoader;
//					_currentLoader=new DataLoader();
					break;
				case LoadType.CONTENT:
					_currentLoader=_contentLoader;
//					_currentLoader=new ContentLoader();
					break;
				case LoadType.CODE:
					_currentLoader=_contentLoader;
//					_currentLoader=new ContentLoader();
					break;
				default:
					startLoad();
					return;
			}
//			_currentLoader.boardcastor.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_currentLoader.startLoad(sub, doneHandler);
		}

		private function doneHandler():void
		{
//			_currentLoader.boardcastor.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			_currentLoader.destroy();
			_currentLoader=null;
			startLoad();
		}
	}
}
