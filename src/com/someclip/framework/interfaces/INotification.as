package com.someclip.framework.interfaces
{

	/**
	 * ...
	 * @author Argus
	 */
	public interface INotification
	{
		/**
		 * 获取或设置消息的内容
		 * @return
		 *
		 */
		function get body():Object;
		function set body(value:Object):void;
		/**
		 * 获取或设置消息的名称
		 * @return
		 *
		 */
		function get name():String;
		function set name(value:String):void;
	}

}
