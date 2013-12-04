package com.someclip.framework.pattern
{
	import com.someclip.events.CarryingEvent;
	import com.someclip.framework.core.SystemConst;
	import com.someclip.framework.interfaces.IBaseView;
	import com.someclip.framework.interfaces.IMediator;
	import com.someclip.framework.interfaces.INotification;

	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author Argus
	 */
	public class Mediator implements IMediator
	{
		private var _mediatorName:String;
		private var _view:IBaseView;
		private var _notifyAcceptable:Boolean=false;

		public function Mediator()
		{
			_mediatorName=getQualifiedClassName(this);
			if (_mediatorName.split("::")[1] == "Mediator")
			{
				throw new Error("Mediator不能直接创建实例，请先继承!");
			}
		}

		/* INTERFACE com.someclip.framework.interfaces.IMediator */

		final public function get mediatorName():String
		{
			return _mediatorName;
		}

		public function get viewComponent():IBaseView
		{
			return _view;
		}

		public function get notifyAcceptable():Boolean
		{
			return _notifyAcceptable;
		}

		public function set notifyAcceptable(value:Boolean):void
		{
			_notifyAcceptable=value;
		}

		public function set viewComponent(view:IBaseView):void
		{
			if (_view != null && view == null)
			{
				_view.removeEventListener(CarryingEvent.SYS_ERROR_EVENT, sysErrorEventHandler);
			}
			if (_view == null)
			{
				_view=view;
				_view.addEventListener(CarryingEvent.SYS_ERROR_EVENT, sysErrorEventHandler);
			}
		}

		private function sysErrorEventHandler(event:CarryingEvent):void
		{
			event.stopPropagation();
			boardcastError(event.data.code, event.data.msg);
		}

		public function onRegister():void
		{

		}

		public function sendRequest(requestCMD:String, requestVars:Object=null, requestMethod:String=""):void
		{
			sendNotification(SystemConst.SEND_REQUEST, {cmd: requestCMD, vars: requestVars, mothed: requestMethod, requester: this.mediatorName});
		}

		public function listInterested():Array
		{
			return [];
		}

		public function sendNotification(notificationName:String, body:Object=null):void
		{
			Facade.instance.sendNotification(notificationName, body);
		}

		public function handleNotification(notification:INotification):void
		{

		}

		public function createView(viewName:String, params:Object=null):void
		{
			sendNotification(SystemConst.CREATE_VIEW, {name: viewName, param: params});
		}

		public function boardcastError(errorCode:String, errorMsg:String):void
		{
			sendNotification(SystemConst.SYS_ERROR_OCCUR, {from: this.mediatorName.substr(this.mediatorName.indexOf("::") + 2).replace("Mediator", ""), code: errorCode, msg: errorMsg});
		}

		public function destory():void
		{
			if (_view)
			{
				_view=null;
			}
		}

		public function destoryModule():void
		{
			//_view.visible=false;
			this.notifyAcceptable=false;
			sendNotification(SystemConst.SYS_DESTORY, this._mediatorName);
		}
	}

}
