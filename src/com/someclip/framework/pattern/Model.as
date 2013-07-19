package com.someclip.framework.pattern 
{
	import com.someclip.framework.interfaces.IModel;
	import com.someclip.framework.interfaces.IProxy;
	
	/**
	 * ...
	 * @author Argus
	 */
	public class Model implements IModel 
	{
		private static var _instance:Model;
		private var proxyMap:Array;
		public function Model() 
		{
			if (_instance) throw new Error("Model,SingletonError!");
			proxyMap = new Array();
		}
		
		public static function get instance():Model
		{
			if (_instance == null)_instance = new Model;
			return _instance;
		}
		
		/* INTERFACE com.someclip.framework.interfaces.IModel */
		
		public function registerProxy(proxy:IProxy):void 
		{
			proxyMap[proxy.proxyName] = proxy;
		}
		
		public function retrieveProxy(proxyName:String):IProxy 
		{
			return proxyMap[proxyName];
		}
		
		public function hasProxy(proxyName:String):Boolean
		{
			return proxyMap[proxyName] != null;
		}
		public function removeProxy(proxyName:String):void 
		{
			proxyMap[proxyName] = null;
		}
		
	}

}