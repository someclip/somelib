package com.someclip.utils.queue
{
	public interface IQueue
	{
		function get queueTitle():String;
		function set queueTitle(value:String):void;
		function get showProgress():Boolean;
		function set showProgress(value:Boolean):void;
		function get completeHandler():Function;
		function set completeHandler(value:Function):void;
		function getNext():IQueueItem;
		function get itemTitle():String;
		function addSub(value:IQueueItem):void;
	}
}