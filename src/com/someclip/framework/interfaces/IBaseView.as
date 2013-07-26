package com.someclip.framework.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IBaseView extends IEventDispatcher
	{
		/**
		 * 获取显示显示对象的名称，例子：com.someclip.view::ExampleView
		 * @return 实例名称
		 *
		 */
		function get viewName():String;
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		/**
		 * 当显示对象添加到舞台的时候，此方法会被调用
		 *
		 */
		function addedToStage():void;
		/**
		 * 显示对象的初始入口，在createView的时候传递的参数会将作为param传入。
		 * @param param 初始化时需要的参数。
		 *
		 */
		function init(param:Object=null):void;
		/**
		 * 显示显示对象，初始化完毕后会自动调用。
		 *
		 */
		function display():void;
		/**
		 * 隐藏显示对象
		 *
		 */
		function hide():void;
		/**
		 * 销毁对象
		 *
		 */
		function destory():void;
	}
}
