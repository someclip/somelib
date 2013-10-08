package com.someclip.ui.richTF
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.ByteArray;

	public class TextFieldExt extends TextField
	{
		private var _richLayer:Sprite;
		private static var replaceLib:Object;
		private var _replaceMents:Object;
		private var _source:String;
		private var _replaceChar:String=String.fromCharCode(12288);
		private var _replaceWidth:Number;
		private var _replaceHeight:Number;
		private var _textFormat:TextFormat;
		private var _startKey:String;
		private var _defaultTextFormat:TextFormat;
		private var _updating:Boolean;
		private var _lastSelection:int;
		private var _lineMatric:TextLineMetrics;
		private var _pickFocusWhenOver:Boolean;
		private var _linkKey:String="";
		private var _isOver:Boolean=false;
		private var _bottomY:Number=0;

		public function TextFieldExt(richLayer:Sprite)
		{
			super.condenseWhite=false;
			_richLayer=richLayer;
			replaceLib={};
			_replaceMents={};
			this.addEventListener(Event.SCROLL, scrollHandler);
			this.addEventListener(MouseEvent.CLICK, clickHandler);
			this.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}

		public function get linkKey():String
		{
			return _linkKey;
		}

		protected function moveHandler(event:MouseEvent):void
		{
			if (this.mouseY > _bottomY)
			{
				if (_isOver)
				{
					_isOver=false;
					_linkKey="";
					dispatchEvent(new Event("TextLinkOut", true));
				}
				return;
			}
			var index:int=super.getCharIndexAtPoint(this.mouseX, this.mouseY);
			if (index != -1)
			{
				var format:TextFormat=super.getTextFormat(index);
				if (format && format.url.indexOf("event:") != -1)
				{
					if (_isOver == false)
					{
						_isOver=true;
						_linkKey=format.url.substr(6);
						dispatchEvent(new Event("TextLinkOver", true));
					}
					else
					{
						if (_linkKey != format.url.substr(6))
						{
							_isOver=false;
							_linkKey="";
							dispatchEvent(new Event("TextLinkOut", true));
						}
					}
				}
				else
				{
					if (_isOver)
					{
						_isOver=false;
						dispatchEvent(new Event("TextLinkOut", true));
					}
					_linkKey="";
				}
			}
			else
			{
				if (_isOver)
				{
					_isOver=false;
					dispatchEvent(new Event("TextLinkOut", true));
				}
				_linkKey="";
			}
		}

		protected function clickHandler(event:MouseEvent):void
		{
			var index:int=super.getCharIndexAtPoint(this.mouseX, this.mouseY);
			if (index != -1)
			{
				var format:TextFormat=super.getTextFormat(index);
				if (format && format.url.indexOf("event:") != -1)
				{
					dispatchEvent(new TextEvent(TextEvent.LINK, true, false, format.url.substr(6)));
				}
			}
		}

		override public function get type():String
		{
			return super.type;
		}

		override public function set type(value:String):void
		{
			super.type=value;
			if (type == TextFieldType.INPUT)
			{
				this.addEventListener(TextEvent.TEXT_INPUT, keyUpHandler);
			}
			else
			{
				if (this.hasEventListener(TextEvent.TEXT_INPUT))
				{
					this.removeEventListener(TextEvent.TEXT_INPUT, keyUpHandler);
				}
			}
		}

		protected function keyUpHandler(event:TextEvent):void
		{
			super.defaultTextFormat=_defaultTextFormat;
			_lastSelection=actualSelectionIndex;
			htmlText=filtText(actualText);
		}

		private function filtText(str:String):String
		{
			str.replace(/\n/g, "");
			var len:uint=0;
			for (var i:uint=0; i < str.length; i++)
			{
				if (str.charCodeAt(i) > 255)
				{
					len+=2;
				}
				else
				{
					len+=1;
				}
				if (len == this.maxChars)
				{
					str=str.substr(0, i);
					break;
				}
				else if (len > this.maxChars)
				{
					str=str.substr(0, i - 1);
					break;
				}
			}
			return str;
		}

		protected function get actualSelectionIndex():int
		{
			var index:int=selectionBeginIndex;
			var stx:String=text.substring(0, index);
			if (stx.length == 0)
				return index;
			for (var key:String in replaceLib)
			{
				while (stx.indexOf(_startKey + key) != -1)
				{
					stx=stx.replace(_startKey + key, "");
					index-=(_startKey + key).length - 1;
				}
			}
			stx=null;
			return index;
		}

		protected function scrollHandler(event:Event):void
		{
			updateRich();
		}

		override public function get defaultTextFormat():TextFormat
		{
			return super.defaultTextFormat;
		}

		override public function set defaultTextFormat(value:TextFormat):void
		{
			_defaultTextFormat=value;
			super.defaultTextFormat=_defaultTextFormat;
		}

		public function get startKey():String
		{
			return _startKey;
		}

		public function set startKey(value:String):void
		{
			_startKey=value;
		}

		override public function set condenseWhite(value:Boolean):void
		{

		}

		public function registReplace(keyword:String, reference:Class):void
		{
			replaceLib[keyword]=reference;

		}

		override public function appendText(newText:String):void
		{
			caculateReplaceWidth();
			super.appendText(newText);
			updateRender();
		}

		override public function get scrollV():int
		{
			return super.scrollV;
		}

		override public function set scrollV(value:int):void
		{
			super.scrollV=value;
			super.defaultTextFormat=_defaultTextFormat;
			updateRich();
		}

		override public function set text(value:String):void
		{
			htmlText=value;
		}

		override public function set htmlText(value:String):void
		{
			_source=value;
			super.defaultTextFormat=_defaultTextFormat;
			caculateReplaceWidth();
			super.htmlText=value;
			updateRender();
		}

		private function updateRender():void
		{
			replaceAllRich();
			super.defaultTextFormat=_defaultTextFormat;
			updateRich();
		}

		private function replaceAllRich():void
		{
			var match:Array=[];
			var reg:RegExp;
			var result:Object
			for (var key:String in replaceLib)
			{
				reg=new RegExp(_startKey + key, "g");
				result=reg.exec(text);
				while (result)
				{
					result.key=key;
					match.push(result);
					result=reg.exec(text);
				}
				reg=null;
				result=null;
			}
			if (match.length > 0)
			{
				match.sort(matchSortFun);
			}
			else
			{
				clearUp();
			}
			var index:int;
			var rkey:String;
			var offset:int=0;
			while (match.length > 0)
			{
				result=match[0];
				index=result.index - offset;
				rkey=result.key;
				if (_replaceMents[index] == undefined)
				{
					_replaceMents[index]=new replaceLib[rkey]();
				}
				else if (!(_replaceMents[index] is replaceLib[rkey]))
				{
					if (_richLayer.contains(_replaceMents[index] as DisplayObject))
					{
						_richLayer.removeChild(_replaceMents[index] as DisplayObject);
					}
					if (_replaceMents[index] is MovieClip)
					{
						(_replaceMents[index] as MovieClip).gotoAndStop(1);
					}
					_replaceMents[index]=null;
					_replaceMents[index]=new replaceLib[rkey]();
				}
				_richLayer.addChild(_replaceMents[index] as DisplayObject);
				var textFormat:TextFormat=getTextFormat(index, index + (_startKey + rkey).length);
				replaceText(index, index + (_startKey + rkey).length, _replaceChar);
				textFormat.letterSpacing=(_replaceMents[index].width) / 2;
				textFormat.font=_startKey + rkey;
				super.setTextFormat(textFormat, index, index + 1);
				offset+=(_startKey + rkey).length - 1;
				textFormat=null;
				match.shift();
			}
			setSelection(_lastSelection, _lastSelection);
		}

		private function matchSortFun(re1:Object, re2:Object):int
		{
			if (re1.index < re2.index)
			{
				return -1;
			}
			else
			{
				return 1;
			}
			return 0;
		}

		public function get actualText():String
		{
			if (text == "")
				return text;
			var str:String=text;
			var index:int=-1;
			var sindex:int=-1;
			var offset:int=0;
			do
			{
				index=str.indexOf(_replaceChar);
				if (index != -1)
				{
					var format:TextFormat=super.getTextFormat(index - offset);
					var key:String=format.font;
					format=null;
					if (key)
					{
						offset+=key.length - 1;
						str=str.replace(_replaceChar, key);
					}
					else
					{
						index=-1;
					}
				}
			} while (index != -1)
			return str;
		}

		private function caculateReplaceWidth():void
		{
			super.text=_replaceChar;
			_lineMatric=getLineMetrics(0);
			var rect:Rectangle=super.getCharBoundaries(0);
			_replaceWidth=rect.width;
			_replaceHeight=rect.height + super.defaultTextFormat.leading;
			rect=null;
		}

		private function updateRich():void
		{
			for (var index:String in _replaceMents)
			{
				if (text.charCodeAt(int(index)) != 12288)
				{
					if (_richLayer.contains(_replaceMents[index] as DisplayObject))
					{
						_richLayer.removeChild(_replaceMents[index] as DisplayObject);
					}
					if (_replaceMents[index] is MovieClip)
					{
						(_replaceMents[index] as MovieClip).gotoAndStop(1);
					}
					_replaceMents[index]=null;
					delete _replaceMents[index];
					continue;
				}
				var bound:Rectangle=super.getCharBoundaries(int(index))
				if (!bound)
				{
					(_replaceMents[index] as DisplayObject).visible=false;
				}
				else
				{
					var lineIndex:Number=super.getLineIndexOfChar(int(index));
					if (lineIndex < scrollV - 1 || lineIndex > bottomScrollV - 1)
					{
						(_replaceMents[index] as DisplayObject).visible=false;
						continue;
					}
					var ty:Number;
					var lineHeight:Number=getLineHeight(lineIndex);
					ty=2 + lineHeight + (bound.height - (_replaceMents[index] as DisplayObject).height) * .5;
					(_replaceMents[index] as DisplayObject).x=bound.left;
					(_replaceMents[index] as DisplayObject).y=ty;
					if ((_replaceMents[index] as DisplayObject).visible == false)
					{
						(_replaceMents[index] as DisplayObject).visible=true;
					}
				}
				bound=null;
			}
			_bottomY=2 + getLineHeight(bottomScrollV - 1) + getLineMetrics(bottomScrollV - 1).height - Number(defaultTextFormat.leading);
		}

		private function getLineHeight(line:int):Number
		{
			var offset:Number=0;
			while (line >= scrollV)
			{
				offset+=getLineMetrics(line--).height;
			}
			return offset;
		}

		private function clearUp():void
		{
			while (_richLayer.numChildren > 0)
			{
				var obj:DisplayObject=_richLayer.getChildAt(0);
				_richLayer.removeChild(obj);
				if (obj is MovieClip)
				{
					(obj as MovieClip).gotoAndStop(1);
				}
				obj=null;
			}
		}

		public function insertText(text:String):void
		{
			if (stage)
			{
				if (stage.focus != this)
				{
					stage.focus=this;
				}
				_lastSelection=actualSelectionIndex;
				var realIndex:int=getRealIndex();
				var actual:String=actualText;
				var front:String=actualText.substring(0, realIndex);
				var last:String=actualText.substr(realIndex);
				actual=front + text + last;
				_lastSelection+=1;
				htmlText=actual;
				actual=null;
				front=null;
				last=null;
			}
		}

		private function getRealIndex():int
		{
			if (text == "")
				return 0;
			var str:String=text;
			var index:int=-1;
			var offset:int=0;
			do
			{
				index=str.indexOf(_replaceChar);
				if (index != -1 && index - offset < selectionBeginIndex)
				{
					var format:TextFormat=super.getTextFormat(index - offset);
					var key:String=format.font;
					format=null;
					if (key)
					{
						offset+=key.length - 1;
						str=str.replace(_replaceChar, key);
					}
					else
					{
						index=-1;
					}
				}
				else
				{
					index=-1;
				}
			} while (index != -1)
			return selectionBeginIndex + offset;
		}
	}
}
