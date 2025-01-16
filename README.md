# Oracle APEX Dynamic Action Plugin - APEX IR Dynamic Item Update

APEX IR Dynamic Item Update es un plugin de acción dinámica para Oracle APEX que permite la actualización en tiempo real de múltiples tipos de elementos dinámicos (APEX_ITEM) en una región interactiva. Este plugin facilita la sincronización automática de los cambios realizados en los elementos con una colección de Oracle APEX, ofreciendo una experiencia de usuario fluida y eficiente.


- [Oracle APEX Dynamic Action Plugin - APEX IR Dynamic Item Update](#oracle-apex-dynamic-action-plugin---apex-ir-dynamic-item-update)
	- [Preview](#preview)
	- [Install](#install)
	- [Plugin Settings](#plugin-settings)
		- [Application settings](#application-settings)
		- [Component settings](#component-settings)
	- [Plugin Events](#plugin-events)
	- [How to use](#how-to-use)
			- [Sample SQL Query for data source](#sample-sql-query-for-data-source)
	- [Demo Application](#demo-application)
	- [Changelog](#changelog)
	- [License](#license)


## Preview
![](https://github.com/silviosotelo/APEX-IR-Dynamic-Update/blob/main/APEX-IR-Dynamic-Update-preview.mp4)


## Install
- Import plugin file "dynamic_action_plugin_com_rws_apex_ir_dynamic_item_update.sql" from **dist** directory into your application

## Plugin Settings
The plugin settings are highly customizable and you can change:

### Application settings
- **Collection Name** - Specify the name of the Oracle APEX collection where updates will be stored.
- **Region ID** - The static ID of the region containing dynamic items to be updated.

### Component settings
- **APEX_ITEM Dynamic Elements**
  - **APEX_ITEM.CHECKBOX2:** - Checkboxes for boolean inputs.
  - **APEX_ITEM.RADIOGROUP:** - Radio groups for single selections.
  - **APEX_ITEM.TEXT:** - Standard text fields.
  - **APEX_ITEM.TEXTAREA:** - Text areas for long inputs
  - **APEX_ITEM.DATE_POPUP2:** - Date pickers.
  - **APEX_ITEM.SELECT_LIST_FROM_LOV:** - Select values from lov list.
- **Custom Attributes** - Set properties such as class, id, and CSS styles for elements.
- **Elements to Send** - Defines the page elements that should be sent to the server along with the AJAX Callback.

## How to use
- Add an interactive report region to your page.
- Configure dynamic items in your query using the APEX_ITEM options.
- Create a Dynamic Action:
- Event: Change.
- Action: APEX IR Dynamic Update.
- Fire on Initialization: On.
- Configure the APEX Collection Name and Region ID.
- Adjust the plugin settings to customize attributes to your application needs.


#### Sample SQL Query for data source

```language-sql
select seq_id
      ,c001 as display_sequence
      ,c002 as question_letter
      ,c003 as question
      ,c004 as question_type
      ,c005 as mandatory_yn
      ,c006 as answer_01
      ,c007 as answer_02
      ,c008 as answer_03
      ,c009 as parent
      , case
            when c004 = 'RADIO_GROUP' then
             apex_item.radiogroup(p_idx            => seq_id
                                 ,p_value          => c006
                                 ,p_selected_value => c008
                                 ,p_display        => c006
                                 ,p_attributes     => case
                                                          when nvl(c008, c007) = c006 then
                                                           'checked="checked" '
                                                          else
                                                           ''
                                                     end || '" class="ir-edit-input"'
                                 ,p_item_id        => 'C-' || seq_id || '-8') || ' ' ||
             apex_item.radiogroup(p_idx            => seq_id
                                 ,p_value          => c007
                                 ,p_selected_value => c008
                                 ,p_display        => c007
                                 ,p_attributes     => case
                                                          when nvl(c008, c007) = c007 then
                                                           'checked="checked" '
                                                          else
                                                           ''
                                                     end || '" class="ir-edit-input"'
                                 ,p_item_id        => 'C-' || seq_id || '-8')
            when c004 = 'CHECKBOX' then
             apex_item.checkbox2(p_idx        => seq_id
                                ,p_value      => case
                                                     when nvl(c008, c007) = c006 then
                                                      c007
                                                     else
                                                      c006
                                                end
                                ,p_attributes => case
                                                     when nvl(c008, c007) = c006 then
                                                      'checked="checked" '
                                                     else
                                                      ''
                                                end || '" class="ir-edit-input"'
                                ,p_item_id    => 'C-' || seq_id || '-8')
            when c004 = 'TEXT' then
             apex_item.text(p_idx        => seq_id
                           ,p_value      => c008
                           ,p_size       => 10
                           ,p_maxlength  => 255
                           ,p_attributes => '" class="ir-edit-input"'
                           ,p_item_id    => 'C-' || seq_id || '-8')
            when c004 = 'TEXTAREA' then
             apex_item.textarea(p_idx        => seq_id
                               ,p_value      => c008
                               ,p_rows       => 3
                               ,p_attributes => '" class="ir-edit-input"'
                               ,p_item_id    => 'C-' || seq_id || '-8')
            when c004 = 'DATE' then
             apex_item.date_popup2(p_idx                 => seq_id
                                  ,p_value               => c012
                                  ,p_date_format         => 'DD/MM/YYYY'
                                  ,p_attributes          => '" class="ir-edit-input"'
                                  ,p_item_id             => 'C-' || seq_id || '-12'
                                  ,p_default_value       => sysdate
                                  ,p_max_value           => to_date(add_months(sysdate, +60), 'DD/MM/YYYY')
                                  ,p_min_value           => to_date(add_months(sysdate, -60), 'DD/MM/YYYY')
                                  ,p_show_on             => 'both'
                                  ,p_number_of_months    => '1'
                                  ,p_navigation_list_for => 'MONTH_AND_YEAR'
                                  ,p_year_range          => '2000:2030'
                                  ,p_validation_date     => c012)
            when c004 = 'SELECT' then
             apex_item.select_list_from_lov(p_idx        => seq_id
                                           ,p_value      => c008
                                           ,p_lov        => 'LOV_APEX_DYNAMIC_UPDATE'
                                           ,p_attributes => '" class="ir-edit-input"'
                                           ,p_show_null  => 'NO'
                                           ,p_item_id    => 'C-' || seq_id || '-10')
       end as dynamic_item
from   apex_collections
where  collection_name = 'COLL_APEX_IR_DYNAMIC_UPDATE';

```


## Demo Application
https://apex.oracle.com/pls/apex/f?p=RWS


## Changelog

#### 1.0.5 - Initial Release


## License
MIT
