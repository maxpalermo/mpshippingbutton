{*
* 2007-2017 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author    PrestaShop SA <contact@prestashop.com>
*  @copyright 2007-2017 PrestaShop SA
*  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}

<style>
.mp-switch 
{
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

.mp-switch input 
{
    display:none;
}

.slider 
{
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before 
{
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider 
{
  background-color: #2196F3;
}

input:focus + .slider 
{
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before 
{
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}

/* Rounded sliders */
.slider.round 
{
  border-radius: 34px;
}

.slider.round:before 
{
  border-radius: 50%;
}
</style>

<div class="panel">
	<h3><i class="icon icon-cogs"></i> {l s='Shipping button configuration' mod='mpmassivetags'}</h3>
	<p>
		<strong>{l s='Here is my new generic module!' mod='mpmassivetags'}</strong><br />
		{l s='Thanks to PrestaShop, now I have a great module.' mod='mpmassivetags'}<br />
		{l s='I can configure it using the following configuration form.' mod='mpmassivetags'}
	</p>
	<br />
	<p>
		{l s='This module will boost your sales!' mod='mpmassivetags'}
	</p>
</div>
<form method="post" enctype="multipart/form-data" class="defaultForm form-horizontal" action='{$form_link}&token={$token}&configure={$configure}'>
<!-- CONFIGURATION PANEL -->
<div class="panel" id="fieldset_0">
	<div class="panel-heading">
		<i class="icon-cogs"></i>Configurazione
	</div>
    <!--FORM COMPONENTS -->
    <div class="form-wrapper">
        <div class="form-group">
        	<input type="hidden" id='input_switch_reset_value' name='input_switch_reset_value'>
			<label class="control-label col-lg-3">{l s='Delete previous data'}</label>
			<div class="col-lg-9">
                <label class="mp-switch">
                    <input type="checkbox" name='input_switch_reset' onclick='switch_click(this);'>
                    <span class="slider round"></span>
                </label>
			</div>
        </div>
        <div class="form-group">
			<label class="control-label col-lg-3">{l s='Choose Supplier'}</label>
			<div class="input-group input fixed-width-xxl">
                <select class='input' id='input_select_supplier' name='input_select_supplier'>
                	<option value='0'>{l s='Default message' mod='mpshippingbutton'}</option>
					{foreach $suppliers as $supplier}
                		<option value="{$supplier['id_supplier']}">
							{$supplier['name']}
						</option>
                	{/foreach}
                </select>
                <span class="input-group-addon"'><i class="icon-truck"></i></span>
            </div>
		</div>
		<div class="form-group">
			<label class="control-label col-lg-3">{l s='Row data'}</label>
			<div class="input-group input">
                <textarea name="content_html" id='input_text_html' class="rte autoload_rte rte autoload_rte"></textarea>
            </div>
		</div>
	</div>
    
	<div class="panel-footer">
		<button type="submit" value="1" id="module_form_submit_btn" name="submitMessage" class="btn btn-default pull-right">
            <i class="process-icon-save"></i>SALVA
        </button>
	</div>
</div>
</form>
<div class="panel">
	<h3><i class='icon icon-list'></i> {l s='Supplier list' mod='mpshippingbutton'}</h3>
	<table class='table' id='table_suppliers'>
		<thead>
			<tr>
				<th>{l s='ID' mod='mpshippingbutton'}</th>
				<th>{l s='ID SUPPLIER' mod='modshippingbutton'}</th>
				<th>{l s='SUPPLIER' mod='modshippingbutton'}</th>
				<th>{l s='MESSAGE' mod='modshippingbutton'}</th>
		</thead>
		<tbody>
			{foreach $messages as $message}
				<td>{$message['id_message']}</td>
				<td>{$message['id_supplier']}</td>
				<td>{$message['name']}</td>
				<td><div>{{$message['message']|htmlspecialchars_decode}}</div></td>
			{/foreach}
		</tbody>
	</table>
</div>
<div class="panel">
	<h3><i class="icon icon-tags"></i> {l s='Documentation' mod='mpmassivetags'}</h3>
	<p>
		&raquo; {l s='You can get a PDF documentation to configure this module' mod='mpmassivetags'} :
		<ul>
			<li><a href="#" target="_blank">{l s='English' mod='mpmassivetags'}</a></li>
			<li><a href="#" target="_blank">{l s='French' mod='mpmassivetags'}</a></li>
		</ul>
	</p>
</div>

<script type="text/javascript">
	var iso = '{$iso|escape:'quotes':'UTF-8'}';
	var pathCSS = '{$smarty.const._THEME_CSS_DIR_|escape:'quotes':'UTF-8'}';
	var ad = '{$ad|escape:'quotes':'UTF-8'}';

    $(document).ready(function()
    {
    	tinySetup({
            editor_selector :"autoload_rte",
            relative_urls : false,
            plugins : "colorpicker link image paste pagebreak table contextmenu filemanager table code media autoresize textcolor fullpage",
            extended_valid_elements : "em[class|name|id],html,head"
        });
		
		$('#input_select_supplier').on('change',function(){
			$.ajax({
                type: 'POST',
                //dataType: 'json',
                url: '{$form_link|escape:'htmlall':'UTF-8'}',
                useDefaultXhrHeader: false,
                data: 
                {
                    token: '{$token|escape:'htmlall':'UTF-8'}',
                    configure: '{$configure}',
                    ajax: true,
                    action: 'changeSupplier',
                    id_supplier: this.value
                }
            })
            .done(function(result){
				tinymce.activeEditor.setContent(result);
            })
            .fail(function(){
                alert('{l s='Error during Message display' mod='mpshippingbutton'}');
            });
		});
        
        $('#input_select_supplier').change();
    });

    function switch_click(checkbox)
    {
		var value = checkbox.checked?1:0;
        $("#" + checkbox.name + "_value").val(value);
    }
    
    function activate_div(div_name, checkbox)
    {
        jAlert('div name: ' + div_name + ', checkbox:' + checkbox.name + '=' + checkbox.checked);
    }
</script>