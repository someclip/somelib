package com.someclip.utils.queue
{
	import flash.system.ApplicationDomain;

	public interface IQueueItem
	{
		function get itemName():String;
		function set itemName(value:String):void;
		function get itemURL():String;
		function set itemURL(value:String):void;
		function get itemType():String;
		function set itemType(value:String):void;
		function get itemVars():Object;
		function set itemVars(value:Object):void;
		function get completeHandler():Function;
		function set completeHandler(value:Function):void;
		function get cacheKey():String;
		function get done():int;
		function set done(value:int):void;
		function get applicationDomain():ApplicationDomain;
		function set applicationDomain(appDomain:ApplicationDomain):void;
	}
}