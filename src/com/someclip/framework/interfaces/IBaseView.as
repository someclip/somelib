package com.someclip.framework.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IBaseView extends IEventDispatcher
	{
		function get viewName():String;
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		function addedToStage():void;
		function init(param:Object=null):void;
		function display():void;
		function hide():void;
		function destory():void;
	}
}
