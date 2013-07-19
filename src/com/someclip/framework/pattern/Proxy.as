package com.someclip.framework.pattern
{
	import com.someclip.framework.interfaces.IBaseView;
	import com.someclip.framework.interfaces.IProxy;

	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author Argus
	 */
	public class Proxy implements IProxy
	{
		private var _proxyName:String;
		private var _view:IBaseView;

		public function Proxy()
		{
			_proxyName=getQualifiedClassName(this)
			if (_proxyName.split("::")[1] == "Proxy")
			{
				throw new Error("Proxy不能直接创建实例，请先继承!");
			}
		}

		/* INTERFACE com.someclip.framework.interfaces.IProxy */
		final public function get proxyName():String
		{
			return _proxyName;
		}

		public function get viewComponent():IBaseView
		{
			return _view;
		}

		public function set viewComponent(view:IBaseView):void
		{
			if (_view == null)
				_view=view;
		}

		public function handleData(requestCMD:String, receivedData:Object):void
		{

		}

		public function sendNotification(notificationName:String, body:Object=null):void
		{
			Facade.instance.sendNotification(notificationName, body);
		}

		public function destory():void
		{

		}

	}

}
