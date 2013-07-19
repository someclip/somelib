package com.someclip.framework.interfaces
{

	/**
	 * ...
	 * @author Argus
	 */
	public interface IProxy
	{
		function get proxyName():String;
		function get viewComponent():IBaseView;
		function set viewComponent(view:IBaseView):void;
		function sendNotification(notificationName:String, body:Object=null):void;
		function handleData(requestCMD:String, receivedData:Object):void;
		function destory():void;
	}

}
