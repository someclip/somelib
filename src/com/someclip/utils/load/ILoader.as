package com.someclip.utils.load
{
	import com.someclip.utils.queue.IQueueItem;

	import flash.events.EventDispatcher;

	public interface ILoader
	{
		function startLoad(value:IQueueItem, doneHandler:Function=null):void;
		function get boardcastor():EventDispatcher;
		function stop():void;
		function destroy():void;
	}
}
