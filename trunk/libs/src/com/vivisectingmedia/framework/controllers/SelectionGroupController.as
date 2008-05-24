/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is ActionScript 3 SelectionGroupController version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.framework.controllers
{
	import com.vivisectingmedia.framework.controllers.interfaces.ISelectableObject;
	import com.vivisectingmedia.framework.datastructures.utils.HashTable;
	
	/**
	 * Provides a set of controls that allows any kind of object to have a selectable state.
	 *  
	 * @author james
	 * 
	 */
	public class SelectionGroupController
	{
		/* STATIC PROPERTIES */
		static private var __instance:SelectionGroupController;
		
		/* PRIVATE PROPERTIES */
		private var _groupId:int = 1;
		private var _itemTable:HashTable;
		private var _groupTable:HashTable;
		
		/* STATIC PUBLIC METHODS */
		/**
		 * Adds a Selectable item to a specificed group id.  The group id should be a unique id that defines the group the item belongs to.
		 * Use the generateNewId() method on this class to verify that the id is unqiue and not in use within the manager.
		 *  
		 * @param item The item to add to the group.
		 * @param groupId The group id to add the item to.
		 * 
		 */
		static public function addItem(item:ISelectableObject, groupId:int):void
		{
			instance.inst_addItem(item, groupId);
		}
		
		/**
		 * Sets the selected property for the specified item and deselects any other items within the same group as the specified item. 
		 * @param item The item to select.
		 * 
		 */
		static public function selectItem(item:ISelectableObject):void
		{
			instance.inst_selectItem(item);
		}
		
		/**
		 * Used to deselect all items in a group.
		 * 
		 * @param group
		 * 
		 */
		static public function deselectAll(group:int):void
		{
			instance.inst_deselectAll(group);
		}
		
		/**
		 * Returns the specified item's group id number.
		 *  
		 * @param item Item to look group up on.
		 * @return The group the item is a member of.
		 * 
		 */
		static public function getItemGroup(item:ISelectableObject):int
		{
			return instance.inst_getItemGroup(item);
		}
		
		/**
		 * Removes the item from the manager and the boung group.  If the item is the last of the group, the group is removed from the manger
		 * as well.
		 *  
		 * @param item The item to remove from the group.
		 * 
		 */
		static public function removeItem(item:ISelectableObject):void
		{
			instance.inst_removeItem(item);
		}
		
		/**
		 * Removes all the items and the group from the manager.
		 *  
		 * @param groupId The group to remove the items from.
		 * 
		 */
		static public function removeAllItems(groupId:int):void
		{
			instance.inst_removeAllItems(groupId);
		}
		
		/**
		 * Used to generate a unique group id.  This should be called when creating a new grouping to verify that the provided id
		 * is unique in the system.
		 *  
		 * @return A unique generated group id. 
		 * 
		 */
		static public function generateNewId():int
		{
			return instance.inst_generateNewId();
		}
		
		/* STATIC PROTECTED METHODS */
		static protected function get instance():SelectionGroupController
		{
			if(!__instance) __instance = new SelectionGroupController(new SingletonLock());
			return __instance;
		}
		
		/**
		 * This method enables automatic testing by allowing an extended wrapper test class
		 * to reset the singleton instance.  By enabling this function we can apply a battery
		 * of tests that need clean instances of the singleton.  This method should not be called
		 * in development and is marked private so not to be ASDoc'd.
		 * 
		 * @private 
		 * 
		 */
		static protected function resetInstance():void
		{
			__instance = new SelectionGroupController(new SingletonLock());
		}
		
		/* PUBLIC METHODS */
		/**
		 * DO NOT CALL.
		 * 
		 * @private 
		 * @param lock
		 * 
		 */
		public function SelectionGroupController(lock:SingletonLock)
		{
			// CONSTRUCTOR
			_groupTable = new HashTable();
			_itemTable = new HashTable();
		}
		
		/* PROTECTED METHODS */
		/**
		 * Method called by the public facade method addItem().
		 *  
		 * @param item
		 * @param groupId
		 * 
		 */		
		protected function inst_addItem(item:ISelectableObject, groupId:int):void
		{
			if(_itemTable.containsKey(item)) removeItem(item); // remove item from existing group
			_itemTable.addItem(item, groupId);
			
			if(_groupTable.containsKey(groupId))
			{
				// add to the existing group
				var groupList:Array = _groupTable.getItem(groupId) as Array;
				groupList.push(item);
			} else {
				// create group then add
				_groupTable.addItem(groupId, new Array(item));
			}
		}
		
		/**
		 * Method called by the public facade method selectItem(). 
		 * @param item
		 * 
		 */
		protected function inst_selectItem(item:ISelectableObject):void
		{
			// get all the items in the group
			if(!_itemTable.containsKey(item)) return; // not in the queue
			var itemList:Array = _groupTable.getItem(_itemTable.getItem(item)) as Array;
			
			// select the item, deselect the rest 
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				var currentItem:ISelectableObject = ISelectableObject(itemList[i]);
				currentItem.selected = (currentItem == item) ? true : false;
			}
		}
		
		/**
		 * Method called by the public facade method deselectAll(). 
		 * @param group
		 * 
		 */
		protected function inst_deselectAll(group:int):void
		{
			// get all the items in the group
			if(!_groupTable.containsKey(group)) return; // not in the queue
			var itemList:Array = _groupTable.getItem(group) as Array;
			
			// select the item, deselect the rest 
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				ISelectableObject(itemList[i]).selected = false;
			}
		}
		
		/**
		 * Method called by the public facade method getItemGroup(). 
		 * @param item
		 * @return 
		 * 
		 */
		protected function inst_getItemGroup(item:ISelectableObject):int
		{
			var group:int = -1;
			if(_itemTable.containsKey(item)) group = _itemTable.getItem(item);
			return group;
		}
		
		/**
		 * Method called by the public facade method removeItem(). 
		 * @param item
		 * 
		 */
		protected function inst_removeItem(item:ISelectableObject):void
		{
			// verify we have the item
			if(!_itemTable.containsKey(item)) return;
			
			// remove the item from the tables
			var group:int = _itemTable.getItem(item);
			var itemList:Array = _groupTable.getItem(group) as Array;
			
			// find the item, remove it
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				if(itemList[i] == item)
				{
					itemList.splice(i, 1);
					break;
				}
			}
			
			// remove from the itemtable
			_itemTable.remove(item);
			
			// see if there are any more items, if not remove the group
			if(itemList.length < 1) _groupTable.remove(group);

		}
		
		/**
		 * Method called by the public facade method removeAllItems(). 
		 * @param groupId
		 * 
		 */
		protected function inst_removeAllItems(groupId:int):void
		{
			// get the group, remove the items
			var itemList:Array = _groupTable.getItem(groupId) as Array;
			
			// find the item, remove it from the itemTable
			var len:int = itemList.length;
			for(var i:uint = 0; i < len; i++)
			{
				_itemTable.remove(ISelectableObject(itemList[i]));
			}
			
			// remove the group
			_groupTable.remove(groupId);
		}
		
		/**
		 * Method called by the public facade method generateNewId(). 
		 * @return 
		 * 
		 */
		protected function inst_generateNewId():int
		{
			return _groupId++;
		}
	}
}

class SingletonLock
{
	public function SingletonLock():void {}
}