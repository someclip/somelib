package com.someclip.ui.interfaces
{
	import flash.text.TextFormat;

	public interface ILabel
	{
		function get text():String;
		function set text(value:String):void;
		function get textAlign():String;
		function set textAlign(value:String):void;
		function get fontSize():uint;
		function set fontSize(value:uint):void;
		function get fontFace():String;
		function set fontFace(value:String):void;
		function get fontColor():uint;
		function set fontColor(value:uint):void;
		function get bold():Boolean;
		function set bold(value:Boolean):void;
		function get textFormat():TextFormat;
		function set textFormat(value:TextFormat):void;
	}
}
