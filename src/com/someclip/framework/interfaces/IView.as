package com.someclip.framework.interfaces 
{
	
	/**
	 * ...
	 * @author Argus
	 */
	public interface IView 
	{		
		function registerMediator(mediator:IMediator):void;
		function retrieveMediator(mediatorName:String):IMediator;
		function removeMediator(mediatorName:String):void;
		function hasMediator(mediatorName:String):Boolean;
		function notifyObserver(note:INotification):void;
		function removeObserver(notificationName:String,mediatorName:String):void
	}
	
}