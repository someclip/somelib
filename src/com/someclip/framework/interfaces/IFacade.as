package com.someclip.framework.interfaces 
{
	
	/**
	 * ...
	 * @author Argus
	 */
	public interface IFacade 
	{
		function registerMediator(mediator:IMediator):void;
		function retrieveMediator(mediatorName:String):IMediator;
		function removeMediator(mediatorName:String):void;
		function hasMediator(mediatorName:String):Boolean;
		function registerProxy(proxy:IProxy):void;
		function retriveProxy(proxyName:String):IProxy;
		function removeProxy(proxyName:String):void;
		function hasProxy(proxyName:String):Boolean;
		function sendNotification(notificationName:String, body:Object=null):void;
	}
	
}