package com.someclip.framework.pattern
{
	import com.someclip.framework.interfaces.IFacade;
	import com.someclip.framework.interfaces.IMediator;
	import com.someclip.framework.interfaces.IProxy;

	/**
	 * ...
	 * @author Argus
	 */
	public class Facade implements IFacade
	{
		private static var _instance:Facade;

		public function Facade()
		{
			if (_instance != null)
				throw new Error("Facade SingletonError!");

		}

		public static function get instance():Facade
		{
			if (!_instance)
				_instance=new Facade();
			return _instance;
		}

		/* INTERFACE com.someclip.framework.interfaces.IFacade */

		public function registerMediator(mediator:IMediator):void
		{
			View.instance.registerMediator(mediator);
		}

		public function retrieveMediator(mediatorName:String):IMediator
		{
			return View.instance.retrieveMediator(mediatorName);
		}

		public function removeMediator(mediatorName:String):void
		{
			View.instance.removeMediator(mediatorName);
		}

		public function hasMediator(mediatorName:String):Boolean
		{
			return View.instance.hasMediator(mediatorName);
		}

		public function removeObserver(notificationName:String,mediatorName:String):void
		{
			View.instance.removeObserver(notificationName,mediatorName);
		}
		
		public function registerProxy(proxy:IProxy):void
		{
			Model.instance.registerProxy(proxy);
		}

		public function retrieveProxy(proxyName:String):IProxy
		{
			return Model.instance.retrieveProxy(proxyName);
		}

		public function removeProxy(proxyName:String):void
		{
			Model.instance.removeProxy(proxyName);
		}

		public function hasProxy(proxyName:String):Boolean
		{
			return Model.instance.hasProxy(proxyName);
		}

		public function sendNotification(notificationName:String, body:Object=null):void
		{
			View.instance.notifyObserver(new Notification(notificationName, body));
		}

		public function boardcastError(errorCode:String, errorMsg:String):void
		{

		}
	}

}
