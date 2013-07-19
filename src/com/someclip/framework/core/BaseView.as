package com.someclip.framework.core
{
	import com.someclip.framework.interfaces.IBaseView;
	import com.someclip.framework.pattern.Facade;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	public class BaseView extends Sprite implements IBaseView
	{
		private var _viewName:String;

		public function BaseView()
		{
			_viewName=getQualifiedClassName(this);
			if (_viewName.split("::")[1] == "BaseView")
			{
				throw new Error("BaseView不能直接创建实例，请先继承!");
			}
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addedToStage();
		}

		public function addedToStage():void
		{

		}

		public function get viewName():String
		{
			return _viewName;
		}

		public function init(param:Object=null):void
		{
		}

		public function display():void
		{
			this.visible=true;
		}

		public function hide():void
		{
			Facade.instance.retrieveMediator(this.viewName.replace("View", "Mediator")).notifyAcceptable=false;
			this.visible=false;
		}

		public function destory():void
		{
		}
	}
}
