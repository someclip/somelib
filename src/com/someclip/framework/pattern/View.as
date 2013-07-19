package com.someclip.framework.pattern
{
	import com.someclip.framework.interfaces.IMediator;
	import com.someclip.framework.interfaces.INotification;
	import com.someclip.framework.interfaces.IView;

	/**
	 * ...
	 * @author Argus
	 */
	public class View implements IView
	{
		private static var _instance:View;
		private var mediatorMap:Array;
		private var interestedMap:Array;

		public function View()
		{
			if (_instance != null)
				throw new Error("View,SingletonError!");
			mediatorMap=new Array();
			interestedMap=new Array();
		}

		public static function get instance():View
		{
			if (!_instance)
				_instance=new View();
			return _instance;
		}

		/* INTERFACE com.someclip.framework.interfaces.IView */

		public function registerMediator(mediator:IMediator):void
		{
			mediatorMap[mediator.mediatorName]=mediator;
			var interest:Array=mediator.listInterested();
			for each (var interestName:String in interest)
			{
				var interestedMediator:Array=interestedMap[interestName];
				if (interestedMediator == null)
				{
					interestedMediator=new Array;
					interestedMap[interestName]=interestedMediator;
				}
				if (interestedMediator.indexOf(mediator) == -1)
				{
					interestedMediator.push(mediator);
				}
			}
			mediator.onRegister();
		}

		public function retrieveMediator(mediatorName:String):IMediator
		{
			return mediatorMap[mediatorName];
		}

		public function removeMediator(mediatorName:String):void
		{
			var mediator:IMediator=mediatorMap[mediatorName];
			if (mediator == null)
				return;
			var interet:Array=mediator.listInterested();
			for each (var interestName:String in interet)
			{
				var interetMediator:Array=interestedMap[interestName];
				interetMediator.splice(interetMediator.indexOf(mediator), 1);
			}
			mediatorMap.splice(mediatorMap.indexOf(mediator), 1);
		}

		public function hasMediator(mediatorName:String):Boolean
		{
			return mediatorMap[mediatorName] != null;
		}

		public function notifyObserver(note:INotification):void
		{
			var interestMediator:Array=interestedMap[note.name];
			if (interestMediator != null && interestMediator.length > 0)
			{
				for each (var mediator:IMediator in interestMediator)
				{
					if (mediator.notifyAcceptable == true)
					{
						mediator.handleNotification(note);
					}
				}
			}
		}
	}

}
