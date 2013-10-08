package com.someclip.ui.richTF
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class RichTF extends Sprite
	{
		private var _w:Number=100;
		private var _h:Number=100;
		private var _richHolder:Sprite;
		private var _tx:TextFieldExt;

		public function RichTF()
		{
			_richHolder=new Sprite();
			addChild(_richHolder);
			fillRichSize();
			_richHolder.x=0;
			_richHolder.y=0;
			_richHolder.mouseChildren=false;
			_richHolder.mouseEnabled=false;
			_tx=new TextFieldExt(_richHolder);
			_tx.mouseEnabled=true;
			addChildAt(_tx, 0);
			_tx.width=_w;
			_tx.height=_h;
			_tx.x=0;
			_tx.y=0;
		}

		private function fillRichSize():void
		{
			_richHolder.graphics.clear();
			_richHolder.graphics.beginFill(0xffffff, 0);
			_richHolder.graphics.drawRect(0, 0, _w, _h);
			_richHolder.graphics.endFill();
		}

		public function get textFileter():Array
		{
			return _tx.filters;
		}

		public function set textFileter(value:Array):void
		{
			_tx.filters=value;
		}

		public function insertText(text:String):void
		{
			_tx.insertText(text);
		}

		public function get selectable():Boolean
		{
			return _tx.selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_tx.selectable=value;
		}

		public function get actualText():String
		{
			return _tx.actualText;
		}

		public function get type():String
		{
			return _tx.type;
		}

		public function set type(value:String):void
		{
			_tx.type=value;
		}

		public function set defaultTextFormat(value:TextFormat):void
		{
			_tx.defaultTextFormat=value;
		}

		public function get defaultTextFormat():TextFormat
		{
			return _tx.defaultTextFormat;
		}

		public function get startKey():String
		{
			return _tx.startKey;
		}

		public function set startKey(value:String):void
		{
			_tx.startKey=value;
		}

		public function registReplace(keyword:String, reference:Class):void
		{
			_tx.registReplace(keyword, reference);
		}

		override public function get height():Number
		{
			return _h;
		}

		override public function set height(value:Number):void
		{
			_h=value;
			fillRichSize();
			_tx.height=_h;
		}

		override public function get width():Number
		{
			return _w;
		}

		override public function set width(value:Number):void
		{
			_w=value;
			fillRichSize();
			_tx.width=_w;
		}

		public function get text():String
		{
			return _tx.text;
		}

		public function set text(value:String):void
		{
			_tx.text=value;
		}

		public function get actualHeight():Number
		{
			return _tx.textHeight;
		}

		public function get scrollV():int
		{
			return _tx.scrollV;
		}

		public function set scrollV(value:int):void
		{
			_tx.scrollV=value;
		}

		public function get maxScrollV():int
		{
			return _tx.maxScrollV;
		}

		public function get wordWrap():Boolean
		{
			return _tx.wordWrap;
		}

		public function set wordWrap(value:Boolean):void
		{
			_tx.wordWrap=value;
		}

		public function get htmlText():String
		{
			return _tx.htmlText;
		}

		public function set htmlText(value:String):void
		{
			_tx.htmlText=value;
		}

		public function get linkKey():String
		{
			return _tx.linkKey;
		}

		public function get maxChars():int
		{
			return _tx.maxChars;
		}

		public function set maxChars(value:int):void
		{
			_tx.maxChars=value;
		}
	}
}
