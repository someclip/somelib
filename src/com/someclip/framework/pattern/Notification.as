package com.someclip.framework.pattern 
{
	import com.someclip.framework.interfaces.INotification;
	
	/**
	 * ...
	 * @author Argus
	 */
	public class Notification implements INotification 
	{
		private var _body:Object;
		private var _name:String;
		public function Notification(notificationName:String,body:Object) 
		{
			_name = notificationName;
			_body = body;
		}
		
		/* INTERFACE com.someclip.framework.interfaces.INotification */
		
		public function get body():Object 
		{
			return _body;
		}
		
		public function set body(value:Object):void 
		{
			_body = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
	}

}