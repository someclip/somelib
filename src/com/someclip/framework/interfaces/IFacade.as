package com.someclip.framework.interfaces
{

	/**
	 * ...
	 * @author Argus
	 */
	public interface IFacade extends IErrorDispatcher
	{
		function registerMediator(mediator:IMediator):void;
		function retrieveMediator(mediatorName:String):IMediator;
		function removeMediator(mediatorName:String):void;
		function hasMediator(mediatorName:String):Boolean;
		function registerProxy(proxy:IProxy):void;
		function retrieveProxy(proxyName:String):IProxy;
		function removeProxy(proxyName:String):void;
		function hasProxy(proxyName:String):Boolean;
		function sendNotification(notificationName:String, body:Object=null):void;
	}

}
