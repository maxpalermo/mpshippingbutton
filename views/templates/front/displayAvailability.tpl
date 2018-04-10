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
    #qty_available {
        background-color: #55c65e;
        border: 1px solid #36943e;
        color: #fff;
        font-weight: 700;
        line-height: 18px;
        display: inline-block;
        padding: 3px 8px 4px;
        margin: 0 auto;
    }
    #qty_not_available {
        background-color: #fe9126;
        border: 1px solid #e4752b;
        color: #fff;
        font-weight: 700;
        line-height: 18px;
        display: inline-block;
        padding: 3px 8px 4px;
        margin: 0 auto;
    }
</style>
<div style='padding: 2px; text-align: center;'>
    {if $product_qty>0}
    	<span id="#qty_available" class="label label-success" style="">{l s='Product available' mod='mpshippingbutton'}</span>
    {else}
    	<span id="#qty_not_available" class="label label-warning" style="">{l s='Product not available' mod='mpshippingbutton'}</span>
    {/if}
</div>