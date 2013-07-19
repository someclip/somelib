package com.someclip.framework.interfaces
{

	/**
	 * ...
	 * @author Argus
	 */
	public interface IMediator
	{
		function get mediatorName():String;
		function get notifyAcceptable():Boolean;
		function set notifyAcceptable(value:Boolean):void;
		function get viewComponent():IBaseView;
		function set viewComponent(view:IBaseView):void;
		function onRegister():void;
		function sendRequest(requestCMD:String, requestVars:Object=null, requestMethod:String=""):void;
		function createView(viewName:String, params:Object=null):void;
		function listInterested():Array;
		function sendNotification(notificationName:String, body:Object=null):void;
		function handleNotification(notification:INotification):void;
		function destory():void;
	}

}
