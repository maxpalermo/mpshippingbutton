<?php

/**
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
*/

// Located in /modules/mymodule/ajax.php
require_once(dirname(__FILE__).'../../../config/config.inc.php');
require_once(dirname(__FILE__).'../../../init.php');

$id_product = (int)Tools::getValue('id_product');
$attr_group = (int)Tools::getValue('attr_group');
$attr_value = (int)Tools::getValue('attr_value');

if ($attr_value==0) {
    print getTotalQty($id_product);
} else {
    print getAttributeQty($id_product, $attr_value);
}
exit();

function getTotalQty($id_product)
{
    $id_lang = Context::getContext()->language->id;
    $product = new ProductCore($id_product);
    $product_qty = $product->getQuantity($id_product);
    
    $smarty = Context::getContext()->smarty;
    $smarty->assign(array(
        'product_qty' => $product_qty,
        'product_name' => $product->name[$id_lang],
        'product_reference' => Tools::strtoupper($product->reference),
    ));
    $table = $smarty->fetch(dirname(__FILE__) . '/views/templates/front/displayAvailability.tpl');
    
    return $table;
}

function getAttributeQty($id_product, $attr_value)
{
    $id_lang = Context::getContext()->language->id;
    $product = new ProductCore($id_product);
    $product_attributes = $product->getAttributeCombinations($id_lang);
    
    $db = Db::getInstance();
    $sql = new DbQueryCore();
    
    $sql->select('pa.id_product_attribute')
    ->from('product_attribute', 'pa')
    ->innerJoin('product_attribute_combination', 'pac', 'pac.id_product_attribute=pa.id_product_attribute')
    ->where('pac.id_attribute = ' . (int)$attr_value)
    ->where('pa.id_product = ' . (int)$id_product);
    
    $id_product_attribute = $db->getValue($sql);
    $product_attributes = $product->getAttributeCombinationsById($id_product_attribute, $id_lang);
    foreach ($product_attributes as $product_attribute) {
        if ($product_attribute['id_attribute'] == $attr_value) {
            $product_qty = (int)$product_attribute['quantity'];
            break;
        }
    }
    
    $smarty = Context::getContext()->smarty;
    $smarty->assign(array(
        'product_qty' => $product_qty,
        'product_name' => $product->name[$id_lang],
        'product_reference' => Tools::strtoupper($product->reference),
    ));
    $table = $smarty->fetch(dirname(__FILE__) . '/views/templates/front/displayAvailability.tpl');
    
    return $table;
}