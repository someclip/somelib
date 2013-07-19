package com.someclip.utils.queue
{
	import flash.system.ApplicationDomain;

	public class QueueItem implements IQueueItem
	{
		private static var loadCount:int=0;
		private var _itemName:String;
		private var _itemURL:String;
		private var _itemType:String;
		private var _itemVars:Object;
		private var _completeHandler:Function;
		private var _cacheKey:String;
		private var _done:int=0;
		private var _applicationDomain:ApplicationDomain;
		public function QueueItem(itemName:String="",itemURL:String="",itemType:String="",itemVars:Object=null,completeHandler:Function=null)
		{
			_itemName=itemName;
			_itemURL=itemURL;
			_itemType=itemType;
			_itemVars=itemVars;
			_completeHandler=completeHandler;
			_cacheKey="load"+loadCount;
			loadCount++;
		}
		
		public function get applicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}
		
		public function set applicationDomain(appDomain:ApplicationDomain):void
		{
			_applicationDomain=appDomain;
		}
		
		public function get done():int
		{
			return _done;
		}
		
		public function set done(value:int):void
		{
			_done=value;
		}
		
		public function get completeHandler():Function
		{
			return _completeHandler;
		}
		
		public function set completeHandler(value:Function):void
		{
			_completeHandler = value;
		}
		
		public function get itemName():String
		{
			return _itemName;
		}
		
		public function set itemName(value:String):void
		{
			_itemName=value;
		}
		
		public function get itemURL():String
		{
			return _itemURL;
		}
		
		public function set itemURL(value:String):void
		{
			_itemURL=value;
		}
		
		public function get itemType():String
		{
			return _itemType;
		}
		
		public function set itemType(value:String):void
		{
			_itemType=value;
		}
		
		public function get itemVars():Object
		{
			return _itemVars;
		}
		
		public function set itemVars(value:Object):void
		{
			_itemVars=value;
		}
		public function get cacheKey():String
		{
			return _cacheKey;
		}
	}
}