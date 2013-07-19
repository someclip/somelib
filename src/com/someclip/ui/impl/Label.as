package com.someclip.ui.impl
{
	import com.someclip.ui.interfaces.ILabel;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Label extends TextField implements ILabel
	{
		private var _text:String;
		private var _format:TextFormat;
		private var _width:Number=100;
		private var _changed:Boolean;

		public function Label()
		{
			_text="";
			_format=new TextFormat();
			super.multiline=false;
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}

		override public function set width(value:Number):void
		{
			_width=value;
			onChanged();
		}

		private function onChanged():void
		{
			_changed=true;
			if (stage)
			{
				stage.invalidate();
			}
		}

		override public function set multiline(value:Boolean):void
		{
		}

		override public function set height(value:Number):void
		{
		}

		private function addToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			stage.addEventListener(Event.RENDER, renderHandler);
			if (_changed)
			{
				stage.invalidate();
			}
		}

		private function renderHandler(event:Event):void
		{
			if (_changed && stage != null)
			{
				super.text=_text;
				super.setTextFormat(_format);
				super.width=_width;
				super.height=super.textHeight + 4;
			}
		}

		override public function get text():String
		{
			return _text;
		}

		override public function set text(value:String):void
		{
			_text=value;
			onChanged();
		}

		public function get textAlign():String
		{
			return _format.align;
		}

		public function set textAlign(value:String):void
		{
			_format.align=value;
			onChanged();
		}

		public function get fontSize():uint
		{
			return _format.size as uint;
		}

		public function set fontSize(value:uint):void
		{
			_format.size=value;
			onChanged();
		}

		public function get fontFace():String
		{
			return _format.font;
		}

		public function set fontFace(value:String):void
		{
			_format.font=value;
			onChanged();
		}

		public function get fontColor():uint
		{
			return _format.color as uint;
		}

		public function set fontColor(value:uint):void
		{
			_format.color=value;
			onChanged();
		}

		public function get bold():Boolean
		{
			return _format.bold;
		}

		public function set bold(value:Boolean):void
		{
			_format.bold=value;
			onChanged();
		}

		public function get textFormat():TextFormat
		{
			return _format;
		}

		public function set textFormat(value:TextFormat):void
		{
			_format=value;
			onChanged();
		}

		override public function setTextFormat(format:TextFormat, beginIndex:int=-1, endIndex:int=-1):void
		{
		}
	}
}
