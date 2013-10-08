package com.someclip.framework.interfaces
{

	/**
	 * ...
	 * @author Argus
	 */
	public interface IModel
	{
		function registerProxy(proxy:IProxy):void;
		function retrieveProxy(proxyName:String):IProxy;
		function removeProxy(proxyName:String):void;
		function hasProxy(proxyName:String):Boolean;
	}

}
