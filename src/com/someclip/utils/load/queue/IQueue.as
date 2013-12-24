package com.someclip.utils.load.queue 
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	
	/**
	 * 队列对象接口
	 * @author Argus
	 */
	public interface IQueue
	{
		function get queueId():int;
		function get showProgress():Boolean;
		function set showProgress(value:Boolean):void;
		function get queueTitle():String;
		function set queueTitle(value:String):void;
		function get queueMethod():String;
		function set queueMethod(value:String):void;
		function get queueParam():Object;
		function set queueParam(value:Object):void;
		function get dataType():String;
		function set dataType(value:String):void;
		function get applicationDomain():ApplicationDomain;
		function set applicationDomain(value:ApplicationDomain):void;
		function get queueURL():String;
		function set queueURL(value:String):void;
		function get queueHandler():Function;
		function set queueHandler(value:Function):void;
		function get data():Object;
		function set data(value:Object):void;
		function get content():DisplayObject;
		function set content(value:DisplayObject):void;
		function get statue():int;
		function set statue(value:int):void;
	}
	
}