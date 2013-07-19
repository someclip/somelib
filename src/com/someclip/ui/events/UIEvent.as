package com.someclip.ui.events
{
	import flash.events.Event;

	public class UIEvent extends Event
	{
		public static const CHANGED:String="changed";

		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
