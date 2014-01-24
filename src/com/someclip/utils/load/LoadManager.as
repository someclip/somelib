package com.someclip.utils.load 
{
	import com.someclip.framework.core.SystemConst;
	import com.someclip.framework.pattern.Facade;
	import com.someclip.utils.load.loader.MultiLoader;
	import com.someclip.utils.load.queue.IQueue;
	import com.someclip.utils.load.queue.Queue;
	
	import flash.events.Event;

	/**
	 * 加载管理类
	 * @author Argus
	 */
	public class LoadManager 
	{
		
		private static var _ins:LoadManager;
		private var _queue:Array;
		private var _loader:MultiLoader;
		private var _callBack:Function;
		public function LoadManager() 
		{
			if (_ins)
				throw new Error("LoadManager单例！！");
			_queue = new Array();
			_loader = new MultiLoader();
			_loader.addEventListener("QUEUE_DONE", queueHandler);
		}
		public static function get instance():LoadManager
		{
			if (!_ins)
				_ins = new LoadManager();
			return _ins;
		}
		public function addQueue(queue:IQueue):void
		{
			//trace("添加:",queue,queue.queueURL,"   到队列中");
			_queue.push(queue);
		}
		
		/**
		 * 当所有队列都加载完成时调用callBack函数（如果有） 
		 * @param callBack
		 * 
		 */
		public function startQueue(callBack:Function=null):void
		{
			//trace("start queue");
			_callBack=callBack;
			checkQueue();
		}
		
		private function checkQueue():void 
		{
			//trace("check:",_queue.length,_loader.free);
			if (_queue.length > 0)
			{
				if(_loader.free)
				{
					_loader.startLoad(_queue[0] as IQueue);
					if((_queue[0] as IQueue).showProgress)
					{
						Facade.instance.sendNotification(SystemConst.REQUIRE_PROGRESS);
					}else
					{
						Facade.instance.sendNotification(SystemConst.HIDE_PROGRESS);
					}
				}
			}else
			{
				endQueue();
			}
		}
		
		public function insertProgressHandler(progressHandler:Function):void
		{
			_loader.progressHandler=progressHandler;
		}
		
		public function removeProgressHandler():void
		{
			_loader.progressHandler=null;
		}
		private function endQueue():void
		{
			if(_callBack!=null)
			{
				_callBack();
				_callBack=null;
			}
		}
		
		private function queueHandler(e:Event):void 
		{
			if (_queue.length > 0)
			{
				if((_queue[0] as IQueue).showProgress)
				{
					Facade.instance.sendNotification(SystemConst.HIDE_PROGRESS);
				}
				_queue.shift();
			}
			if (_queue.length > 0)
			{
				checkQueue();
			}else
			{
				endQueue();
			}
		}
		
		public function removeQueues(list:Array):void
		{
			for each(var queue:IQueue in list)
			{
				removeQueue(queue);
			}
		}
		
		public function removeQueue(queue:IQueue):void
		{
			var isCurrent:Boolean;
			for(var i:int=0;i<_queue.length;i++)
			{
				if(_queue[i]==queue)
				{
					_queue.splice(i,1);
					i--;
					if(_loader.queue==queue)
					{
						_loader.stopAndQuit();
						isCurrent=true;
					}
				}
			}
			if(isCurrent)
			{
				checkQueue();
			}
		}
		
		public function stopAll():void
		{
			if(_loader)
			{
				_loader.stopAndQuit();
			}
			_queue.length=0;
			_loader.progressHandler=null;
			_callBack=null;
			Facade.instance.sendNotification(SystemConst.HIDE_PROGRESS);
		}
	}

}