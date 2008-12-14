package com.vivisectingmedia.framework.controllers.interfaces
{
	import com.vivisectingmedia.framework.controllers.SelectionGroup;
	
	public interface ISelectableGroup extends ISelectable
	{
		
		/**
		 * Read/Write method of the selection group. Selection Group is used
		 * to handle a group of ISelectableGroup items.
		 */
		function set group(value:SelectionGroup):void;
		
		function get group():SelectionGroup;
	}
}