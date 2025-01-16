prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.10.01'
,p_release=>'20.2.0.00.20'
,p_default_workspace_id=>110000
,p_default_application_id=>400
,p_default_id_offset=>0
,p_default_owner=>'ANAMNESIS'
);
end;
/
 
prompt APPLICATION 400 - Santa Clara
--
-- Application Export:
--   Application:     400
--   Name:            Santa Clara
--   Date and Time:   14:25 Wednesday January 15, 2025
--   Exported By:     SOTELOS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 748117404819559988
--   Manifest End
--   Version:         20.2.0.00.20
--   Instance ID:     69430136799558
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/rws_apex_ir_dynamic_item_update
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(748117404819559988)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'RWS.APEX.IR.DYNAMIC.ITEM.UPDATE'
,p_display_name=>'APEX IR Dynamic Item Update'
,p_category=>'COMPONENT'
,p_supported_ui_types=>'DESKTOP'
,p_css_file_urls=>'#PLUGIN_FILES#custom_styles.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function g_render(',
'     p_dynamic_action in apex_plugin.t_dynamic_action,',
'     p_plugin         in apex_plugin.t_plugin',
') return apex_plugin.t_dynamic_action_render_result as',
'    vr_result apex_plugin.t_dynamic_action_render_result;',
'begin',
unistr('    -- Depuraci\00F3n opcional'),
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action(p_plugin => p_plugin, p_dynamic_action => p_dynamic_action);',
'    end if;',
'',
unistr('    -- Configura la funci\00F3n JavaScript que se ejecutar\00E1'),
'    vr_result.javascript_function := ''',
'        function () {',
'            var ajaxIdentifier = '' || apex_javascript.add_value(apex_plugin.get_ajax_identifier, false) || '';',
'            var regionSelector = '' || apex_javascript.add_value(p_dynamic_action.attribute_01, false) || ''";',
'            var collectionName = '' || apex_javascript.add_value(p_dynamic_action.attribute_02, false) || '';',
'',
'            $("#" + regionSelector).find("td .ir-edit-input").change(function () {',
'                var $input = $(this);',
'                apex.server.plugin(ajaxIdentifier, {',
'                    x01: $input.attr("id"),  // Enviar el ID del input',
'                    x02: collectionName,     // Enviar el nombre de la coleccion',
'                    f01: [$input.val()]      // Enviar el valor del input',
'                }, {',
'                    beforeSend: function () {',
'                        $input.prop("disabled", true).parent("td").addClass("ui-autocomplete-loading");',
'                    },',
'                    success: function (pData) {',
'                        if (!pData.success) {',
'                            apex.message.showErrors({',
'                                type: "error",',
'                                location: "page",',
'                                message: pData.message,',
'                                unsafe: false',
'                            });',
'                            $input.val($input.data("last-value")).prop("disabled", false).parent("td").removeClass("ui-autocomplete-loading");',
'                            return false;',
'                        }',
unistr('                        // Refresca la regi\00F3n interactiva despu\00E9s de guardar el valor'),
'                        $("#" + regionSelector).trigger("apexrefresh");',
'                    },',
'                    complete: function () {',
'                        $input.prop("disabled", false).parent("td").removeClass("ui-autocomplete-loading");',
'                    },',
'                    error: function () {',
'                        apex.message.alert("An error occurred while updating the value.");',
'                    }',
'                });',
'            });',
'        }',
'    '';',
'',
'    return vr_result;',
'end;',
'',
'',
'function g_ajax(',
'     p_dynamic_action in apex_plugin.t_dynamic_action,',
'     p_plugin         in apex_plugin.t_plugin',
') return apex_plugin.t_dynamic_action_ajax_result is',
'    vr_result apex_plugin.t_dynamic_action_ajax_result;',
'begin',
'    -- Ejecuta el proceso PL/SQL proporcionado',
'    begin',
'        -- Inicializa el objeto JSON',
'        APEX_JSON.INITIALIZE_OUTPUT;',
'',
'        -- Comienza el objeto JSON',
'        APEX_JSON.OPEN_OBJECT;',
'        declare',
'            l_val      varchar2(32700);',
'            l_len      pls_integer := 0;',
'            l_data     clob;',
'            l_date_val date;',
'            l_num_val  number;',
'            l_arr      APEX_APPLICATION_GLOBAL.VC_ARR2;',
'            l_collection_name varchar2(255);',
'        begin',
unistr('            -- Obtener el nombre de la colecci\00F3n desde X02'),
'            l_collection_name := APEX_APPLICATION.G_X02;',
'',
unistr('            -- Validar que el nombre de la colecci\00F3n no sea nulo'),
'            if l_collection_name is null then',
'                APEX_JSON.WRITE(''success'', false);',
'                APEX_JSON.WRITE(''status'', ''error'');',
'                APEX_JSON.WRITE(''message'', ''Collection name (x02) cannot be null.'');',
'                --return;',
'            end if;',
'',
'            -- Obtener el valor principal desde G_F01',
'            l_len := APEX_APPLICATION.G_F01.COUNT;',
'',
'            if l_len > 0 then',
'                l_val := APEX_APPLICATION.G_F01(1);',
'            end if;',
'',
'            -- Convertir G_X01 en un array utilizando APEX_UTIL',
'            l_arr := APEX_UTIL.STRING_TO_TABLE(APEX_APPLICATION.G_X01, ''-'');',
'',
unistr('            -- Validar tipo de operaci\00F3n basado en el primer elemento del array'),
'            case l_arr(1)',
'                when ''C'' then',
'                    -- Actualizar atributo de texto (cadena)',
'                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(',
'                        p_collection_name => l_collection_name,',
'                        p_seq             => l_arr(2),',
'                        p_attr_number     => l_arr(3),',
'                        p_attr_value      => l_val',
'                    );',
'',
'                when ''N'' then',
unistr('                    -- Validar y actualizar atributo num\00E9rico'),
'                    begin',
'                        l_num_val := TO_NUMBER(l_val);',
'                    exception',
'                        when VALUE_ERROR then',
'                            APEX_JSON.WRITE(''success'', false);',
'                            APEX_JSON.WRITE(''status'', ''error'');',
'                            APEX_JSON.WRITE(''message'', ''Invalid number format.'');',
'                            --return;',
'                    end;',
'',
'                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(',
'                        p_collection_name => l_collection_name,',
'                        p_seq             => l_arr(2),',
'                        p_attr_number     => l_arr(3),',
'                        p_number_value    => l_num_val',
'                    );',
'',
'                when ''D'' then',
'                    -- Validar y actualizar atributo de fecha',
'                    begin',
'                        l_date_val := TO_DATE(l_val, ''DD/MM/YYYY'');',
'                    exception',
'                        when others then',
'                            APEX_JSON.WRITE(''success'', false);',
'                            APEX_JSON.WRITE(''status'', ''error'');',
'                            APEX_JSON.WRITE(''message'', ''Invalid date format.'');',
'                            --return;',
'                    end;',
'',
'                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(',
'                        p_collection_name => l_collection_name,',
'                        p_seq             => l_arr(2),',
'                        p_attr_number     => l_arr(3),',
'                        p_date_value      => l_date_val',
'                    );',
'',
'                when ''CLOB'' then',
'                    -- Manejo de CLOB',
'                    if l_len = 0 or COALESCE(LENGTH(APEX_APPLICATION.G_F01(1)), 0) = 0 then',
'                        -- Actualizar con valor NULL si no hay datos',
'                        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(',
'                            p_collection_name => l_collection_name,',
'                            p_seq             => l_arr(2),',
'                            p_clob_number     => 1,',
'                            p_clob_value      => null',
'                        );',
'                    else',
'                        -- Construir y actualizar el CLOB',
'                        DBMS_LOB.CREATETEMPORARY(lob_loc => l_data, cache => true, dur => DBMS_LOB.SESSION);',
'                        DBMS_LOB.OPEN(l_data, DBMS_LOB.LOB_READWRITE);',
'',
'                        for i in 1 .. l_len loop',
'                            DBMS_LOB.WRITEAPPEND(lob_loc => l_data,',
'                                                 amount  => LENGTH(APEX_APPLICATION.G_F01(i)),',
'                                                 buffer  => APEX_APPLICATION.G_F01(i));',
'                        end loop;',
'',
'                        DBMS_LOB.CLOSE(l_data);',
'',
'                        APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(',
'                            p_collection_name => l_collection_name,',
'                            p_seq             => l_arr(2),',
'                            p_clob_number     => 1,',
'                            p_clob_value      => l_data',
'                        );',
'                    end if;',
'            end case;',
'',
unistr('            -- Respuesta de \00E9xito'),
'            APEX_JSON.WRITE(''success'', true);',
'            APEX_JSON.WRITE(''status'', ''ok'');',
'            APEX_JSON.WRITE(''message'', ''Attribute updated successfully.'');',
'        exception',
'            when others then',
'                APEX_JSON.WRITE(''success'', false);',
'                APEX_JSON.WRITE(''status'', ''error'');',
'                APEX_JSON.WRITE(''message'', sqlerrm);',
'        end;',
'        -- Cierra el objeto JSON',
'        APEX_JSON.CLOSE_OBJECT;',
'',
'        -- Recuperar el contenido JSON',
'        --vr_result := apex_json.get_clob_output;',
'',
'        -- Finaliza el contenido JSON',
'        APEX_JSON.FREE_OUTPUT;',
'    end;',
'',
'    return vr_result;',
'end;',
''))
,p_api_version=>2
,p_render_function=>'g_render'
,p_ajax_function=>'g_ajax'
,p_standard_attributes=>'REGION'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/silviosotelo/APEX-IR-Dynamic-Update'
,p_files_version=>3
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(748117685788565846)
,p_plugin_id=>wwv_flow_api.id(748117404819559988)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Region ID'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_show_in_wizard=>false
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(748117973217567572)
,p_plugin_id=>wwv_flow_api.id(748117404819559988)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Collection Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_show_in_wizard=>false
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '47494638396110001000C40000FFFFFFEEEEEEDDDDDDBBBBBBAAAAAA999999888888777777666666555555444444333333222222111111001100000000FFFFFF000000000000000000000000000000000000000000000000000000000000000000000000';
wwv_flow_api.g_varchar2_table(2) := '00000000000000000021FF0B4E45545343415045322E30030100000021F90405070010002C0000000010001000000577202442018924E5A842022304CF2390AB283C4CE0C8C1AC0A33C3C3B003A64401C510E648245EB69440E918F890506480B0B82255';
wwv_flow_api.g_varchar2_table(3) := '0685B3502305CE6185825C3B9FCD83C331AA0A181A0A6FCF3A3A300A7606400204247C2C33020B03040502825F230109071005640280350207339722037335030365210021F90405070010002C000000000F00100000056320248ED0818801392A22230A';
wwv_flow_api.g_varchar2_table(4) := '0DA18A0BC438F633CC62C13485076B9400421A0BD3E3914A89129085603498F2863C08017138ECB290420281F8825F859973445040550181D3A0901564AFD75A84100C0801662A07697F228228052986105659028E23210021F90405070010002C000000';
wwv_flow_api.g_varchar2_table(5) := '0010000F0000056020248E506190A888880A13044B2A3A09D406751A9410D11223C140745800170A832126303C1E0255232712149E8FE16880D86D1F27D1405988A25E68C2612D6BF7DC2884C1EB2E1C8683019A4EF21A048010027C2405438101662940';
wwv_flow_api.g_varchar2_table(6) := '82667C210021F90405070010002C000000001000100000056220248E62419EE21140892226030A2D07EB22E82A36431BE30181C880102A0E85822B606AE80E34880E3260C8203592B0185815080419A2D170C09205E109F1682F48B193602ED0090CA6EB';
wwv_flow_api.g_varchar2_table(7) := '689086CCF5522201035D535703425D807E8286808A28210021F90405070010002C0000000010000E0000054920248ED07190A89888CFC3A6ECDA420D2C1E6E5BD068D20C90C7C2E42A054789C70A55DC9196A8C548002938A3AD47CD744AD55E53D44098';
wwv_flow_api.g_varchar2_table(8) := 'BA8EC62D2A446DCBA6D8A40154048785000021F90405070010002C000000001000100000057120248ED03090281410A27188879006076B1890C1C8A98008374103471A10648682E9B0283114A2C0C030088C02820464C1130958A480A2605509CE655221';
wwv_flow_api.g_varchar2_table(9) := '915018CEE85481C16820C228C1A280C276215F225051025601650D0F59100D6929040F5A106078230C0F2733790F7C299E8E210021F90405070010002C000000001000100000056020248E902090A8388845C1A6EC49B885028B4630430A819A01DDC054';
wwv_flow_api.g_varchar2_table(10) := '40881446916098423412A8C00985F08982411801818062035AC56271B88D1204AC19B28220C0B0038201091817B7C6C300292F61017A5353800E0F260E5680090B7024210021F90405070010002C0000010010000F0000055E20244282380C2231AE10DA';
wwv_flow_api.g_varchar2_table(11) := 'A203C2AE308AB881988B4209110752C2300A0876ABC322C8428E0CAED96C70A8AAA4A3586288D5DDA4469F910161B21E0F834141262A5886C781C12840883301BAD4082CB0040F280D7D100C512B3E100952210021F90405070010002C00000000100010';
wwv_flow_api.g_varchar2_table(12) := '0000056320248E501090A8784282200E2B2A9C2D5BC464E0B681E1A22B93694010190A296001814CA20A3F274960A84A478283B6F8620C50BEA9E2F1688E140D83CAF158B81805024201293010A2C2D7B858149B51230C017D10090E4E0E6F0B2274492B';
wwv_flow_api.g_varchar2_table(13) := '5A49210021F90405070010002C0000010010000F0000055C20248E50600602A98AA638ACEAF9AEA92AD4C50C8F843104B6950E82681811308272B0783815B042C18712141AB5516107F98D0288C556C42006180AA521D14D1C44846C21A118340825D802';
wwv_flow_api.g_varchar2_table(14) := '42871CF64265100A50445930060630210021F90405070010002C0000010010000F0000055D20248E241494E81808A5C0A2C2493E8F51CAC1F00EF4F38E025DE9F020B464228632051938050947A371483909AF004181329612A29FC880F0421690AA22E1';
wwv_flow_api.g_varchar2_table(15) := '2C204487824828271C100234B3C1BD430A5C3081086001554C22057228210021F90409070010002C000000001000100000056420248E64490E8D60AEC3C3AC6BF210B0F842C2F39842200AB7026D14E8950A8E41C937322C140A83A928501D1858E9B2AA';
wwv_flow_api.g_varchar2_table(16) := '82F806099392143840522582610C094B11872AA18013FE44A881C18CE83245010B08107B1004077F2483846610743586432521003B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(748118747474586955)
,p_plugin_id=>wwv_flow_api.id(748117404819559988)
,p_file_name=>'ui-anim_basic_16x16.gif'
,p_mime_type=>'image/gif'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E75692D6175746F636F6D706C6574652D6C6F6164696E67207B0D0A20202020206261636B67726F756E643A2075726C282223504C5547494E5F46494C45532375692D616E696D5F62617369635F31367831362E6769662229206E6F2D72657065617420';
wwv_flow_api.g_varchar2_table(2) := '7363726F6C6C203939252031302520234546454645462021696D706F7274616E743B0D0A7D0D0A0D0A2E6170657869725F574F524B53484545545F44415441207464207B0D0A202020202070616464696E672D72696768743A20323270782021696D706F';
wwv_flow_api.g_varchar2_table(3) := '7274616E743B0D0A202020202077686974652D73706163653A206E6F777261703B0D0A2020202020766572746963616C2D616C69676E3A20746F703B0D0A7D0D0A0D0A2E6170657869725F574F524B53484545545F44415441202E69722D656469742D69';
wwv_flow_api.g_varchar2_table(4) := '6E707574207B0D0A2020202020636F6C6F723A20696E68657269743B0D0A2020202020746578742D616C69676E3A20696E68657269743B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(748119303072603671)
,p_plugin_id=>wwv_flow_api.id(748117404819559988)
,p_file_name=>'custom_styles.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
