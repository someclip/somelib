package com.someclip.framework.interfaces
{

	/**
	 * ...
	 * @author Argus
	 */
	public interface IProxy
	{
		/**
		 * 获取当前proxy的名称，example:com.someclip.proxy::ExampleProxy
		 * @return
		 *
		 */
		function get proxyName():String;
		/**
		 * 获取或设置当前proxy所关联的显示对象,当一个proxy处理完一个服务器请求后，如果仅仅需要进行显示层更新，可以直接通过调用显示对象的方法进行更新
		 * @return
		 *
		 */
		function get viewComponent():IBaseView;
		function set viewComponent(view:IBaseView):void;
		/**
		 * 发出消息
		 * @param notificationName 消息名
		 * @param body 消息实体内容
		 *
		 */
		function sendNotification(notificationName:String, body:Object=null):void;
		/**
		 * 当对应的mediator发出的服务器请求成功时，此方法会被回调。
		 * @param requestCMD 请求的命令
		 * @param receivedData 收到的服务端返回数据
		 *
		 */
		function handleData(requestCMD:String, receivedData:Object):void;
		/**
		 * 销毁当前proxy
		 *
		 */
		function destory():void;
	}

}
