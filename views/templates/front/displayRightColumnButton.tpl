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
* {
    box-sizing: border-box;
}    
.btnFeatureProduct {
    -moz-box-shadow:inset 0px 1px 0px 0px #54a3f7;
    -webkit-box-shadow:inset 0px 1px 0px 0px #54a3f7;
    box-shadow:inset 0px 1px 0px 0px #54a3f7;
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #007dc1), color-stop(1, #0061a7));
    background:-moz-linear-gradient(top, #007dc1 5%, #0061a7 100%);
    background:-webkit-linear-gradient(top, #007dc1 5%, #0061a7 100%);
    background:-o-linear-gradient(top, #007dc1 5%, #0061a7 100%);
    background:-ms-linear-gradient(top, #007dc1 5%, #0061a7 100%);
    background:linear-gradient(to bottom, #007dc1 5%, #0061a7 100%);
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#007dc1', endColorstr='#0061a7',GradientType=0);
    background-color:#007dc1;
    -moz-border-radius:3px;
    -webkit-border-radius:3px;
    border-radius:3px;
    border:1px solid #124d77;
    display:inline-block;
    cursor:pointer;
    color:#ffffff;
    font-family:Arial;
    font-size:13px;
    padding:6px 24px;
    text-decoration:none;
    text-shadow:0px 1px 0px #154682;
    margin: 0 auto;
    margin-top: 2px;
    margin-bottom: 2px;
}
.btnFeatureProduct:hover {
    background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #0061a7), color-stop(1, #007dc1));
    background:-moz-linear-gradient(top, #0061a7 5%, #007dc1 100%);
    background:-webkit-linear-gradient(top, #0061a7 5%, #007dc1 100%);
    background:-o-linear-gradient(top, #0061a7 5%, #007dc1 100%);
    background:-ms-linear-gradient(top, #0061a7 5%, #007dc1 100%);
    background:linear-gradient(to bottom, #0061a7 5%, #007dc1 100%);
    filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#0061a7', endColorstr='#007dc1',GradientType=0);
    background-color:#0061a7;
    color: #ffffff;
}
.btnFeatureProduct:active {
    position:relative;
    top:1px;
}

.btnFeatureProduct:visited {
    text-decoration: none;
}

#divDisplayShippingRules {
    position: fixed;
    margin: auto;
    margin-top: 24px;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    width: 80%;
    height: 100%;
    overflow-y: auto;
    background-color: transparent;
    border-radius: 3px;
    z-index: 100000;
    display:none;
}
@media only screen and (max-width: 500px) {
    #table-features-list {
        width: 100% !important;
    }
}
</style>
<div id="product-available-module">
    <div id='divDisplayProductAvailability' style='display: none;'>

    </div>
    
    <div id="displayPopupShippingRule" style='text-align: center;'>
        <button type="button" id='btnDisplayShippingRule' class='btnFeatureProduct'>
            <i class='icon icon-truck'></i>
            <span>{l s='Show shipping rules' mod='mpshippingbutton'}</span>
        </button>
    </div>

    <div id="divDisplayShippingRules" style='display: none;'>
        <div class='panel' style='padding: 10px; border: 1px solid #aaaaaa; border-radius: 5px; box-shadow: 4px 4px 16px #555;'>
            {$html_content}    	
        </div>
    </div>
    
    <div id="displaySizeChart" style='text-align: center;'>
        <button type="button" id='btnDisplaySizeChart' class='btnFeatureProduct' onclick="window.open('../img/taglie.pdf')">
            <i class='icon icon-bookmark-empty'></i>
            <span>{l s='Display size chart' mod='mpshippingbutton'}</span>
        </button>
    </div>
</div>
<script type='text/javascript'>
    $(document).ready(function(){
        $('#product-available-content').html($('#product-available-module').html());
        $('#product-available-module').remove();
        
        
        var radio_btn = $('input[class="attribute_radio"]');
        var found = false;

        for (var i=0; i<radio_btn.length; i++)
        {
                var class_name = $(radio_btn[i]).closest('span').attr('class');
                if (class_name != undefined) {

                        if (class_name.indexOf('checked') !== -1) {
                                getProductAvailability(radio_btn[i]);
                                found=true;
                                break;
                        }
                }
        }

        if (found===false) {
            getProductAvailability(null);
        }
		
        $("#displayPopupShippingRule").on('click', function(){
        	$('#divDisplayShippingRules').fadeIn();
        });
        
        $("#divDisplayShippingRules").on('click', function(){
            $(this).fadeOut();
        });

        $(document).on('click', '.attribute_radio', function(e){
        	e.preventDefault();
        	getProductAvailability(this);
        });
    });

    function getProductAvailability(radio)
    {
		if (radio===null) {
			var attr_group = 0;
			var attr_value = 0;
		} else {
			var attr_group = String($(radio).attr('name')).substr(6);
			var attr_value = $(radio).val();
		}

		$.ajax({
            type: 'POST',
            //dataType: 'json',
            url: '{$url|escape:'htmlall':'UTF-8'}',
            useDefaultXhrHeader: false,
            data: 
            {
                //token: '{$token|escape:'htmlall':'UTF-8'}',
                ajax: true,
                action: 'displayAvailability',
                id_product: {$id_product|escape:'htmlall':'UTF-8'},
            	attr_group: attr_group,
            	attr_value: attr_value,
            }
        })
        .done(function(result){
            $('#divDisplayProductAvailability').html(result).fadeIn();
        })
        .fail(function(){
            alert('{l s='Error during Feature display' mod='mpfeatureproduct'}');
        }); 
    }
</script>
        