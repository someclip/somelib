package com.someclip.events
{
	import flash.events.Event;

	public class CarryingEvent extends Event
	{
		private var _data:Object;


		public static const SYS_ERROR_EVENT:String="sys_error_event";

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data=value;
		}

		public function CarryingEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data=data;
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new CarryingEvent(this.type, this.data, this.bubbles, this.cancelable);
		}
	}
}
