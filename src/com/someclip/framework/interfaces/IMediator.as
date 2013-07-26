package com.someclip.framework.interfaces
{

	/**
	 * ...
	 * @author Argus
	 */
	public interface IMediator
	{
		/**
		 * 获取当前mediator的全名，example:com.someclip.mediator:ExampleMediator
		 * @return
		 *
		 */
		function get mediatorName():String;
		/**
		 * 获取或设置当前mediator是否接受消息，当设置viewComponent的visible为false时不接受消息。
		 * 可以通过指定notifyAccepatble为true,实现viewComponent不显示的时候也接受消息。
		 * @return
		 *
		 */
		function get notifyAcceptable():Boolean;
		function set notifyAcceptable(value:Boolean):void;
		/**
		 * 设置或获取当前mediator所关联的显示对象
		 * @return
		 *
		 */
		function get viewComponent():IBaseView;
		function set viewComponent(view:IBaseView):void;
		/**
		 * 当mediator被注册的时候会调用此方法。
		 *
		 */
		function onRegister():void;
		/**
		 * 发送服务端请求
		 * @param requestCMD 请求的命令
		 * @param requestVars 请求的参数
		 * @param requestMethod 请求的方法GET,POST
		 */
		function sendRequest(requestCMD:String, requestVars:Object=null, requestMethod:String=""):void;
		/**
		 * 创建其他视图模块的方法
		 * @param viewName 模块的名称
		 * @param params 目标模块初始化是需要的参数
		 *
		 */
		function createView(viewName:String, params:Object=null):void;
		/**
		 * 获取当前mediator感兴趣的所有消息类型
		 * @return ["消息类型1"，"消息类型2"]
		 *
		 */
		function listInterested():Array;
		/**
		 * 发出消息
		 * @param notificationName 消息类型名
		 * @param body 消息实体内容
		 *
		 */
		function sendNotification(notificationName:String, body:Object=null):void;
		/**
		 * 当mediator感兴趣的消息发生时，此方法会被调用
		 * @param notification 消息体
		 *
		 */
		function handleNotification(notification:INotification):void;
		/**
		 * 销毁当前mediator
		 *
		 */
		function destory():void;
	}

}
