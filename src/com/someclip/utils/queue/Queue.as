package com.someclip.utils.queue
{
	public class Queue implements IQueue
	{
		private var _queueTitle:String;
		private var _showProgress:Boolean;
		private var _completeHandler:Function;
		private var _queue:Array;
		private var _index:int=0;
		/**
		 * 创建一个队列。 
		 * @param queueTitle 队列名称，可用于progressbar的现实
		 * @param completeHandler 队列结束回调方法
		 * @param showProgress Boolean,标识是否显示进度条
		 * 
		 */
		public function Queue(queueTitle:String="",completeHandler:Function=null,showProgress:Boolean=false)
		{
			_queueTitle=queueTitle;
			_showProgress=showProgress;
			_completeHandler=completeHandler;
			_queue=new Array();	
		}
		
		/**
		 * 获取或设置队列名称 
		 * @return 队列名称
		 * 
		 */
		public function get queueTitle():String
		{
			return _queueTitle;
		}
		public function set queueTitle(value:String):void
		{
			_queueTitle=value;
		}
		/**
		 * 获取或设置队列结束时的回调函数 
		 * @return 
		 * 
		 */
		public function get completeHandler():Function
		{
			return _completeHandler;
		}
		
		public function set completeHandler(value:Function):void
		{
			_completeHandler = value;
		}

		/**
		 * 获取或设置是否显示进度条的标识 
		 * @return 
		 * 
		 */
		public function get showProgress():Boolean
		{
			return _showProgress;
		}
		
		public function set showProgress(value:Boolean):void
		{
			_showProgress=value;
		}

		/**
		 * 添加队列元素
		 * @see com.someclip.utils.queue.IQueueItem;
		 * @see com.someclip.utils.queue.QueueItem; 
		 * @param value 队列元素
		 * 
		 */
		public function addSub(value:IQueueItem):void
		{
			_queue.push(value);
			_index=0;
		}
		
		/**
		 * 获取下一个队列元素用于加载 
		 * @return 队列元素
		 * 
		 */
		public function getNext():IQueueItem
		{
			if(_index<_queue.length)
			{
				_index++;
				return _queue[_index-1] as IQueueItem;
			}
			return null;
		}
		public function get itemTitle():String
		{
			return (_queue[_index-1] as IQueueItem).itemName;
		}
	}
}