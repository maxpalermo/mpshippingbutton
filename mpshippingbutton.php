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

if (!defined('_PS_VERSION_')) {
    exit;
}

class MpShippingButton extends Module
{
    protected $config_form = false;

    public function __construct()
    {
        $this->name = 'mpshippingbutton';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Digital Solutions®';
        $this->need_instance = 0;

        /**
         * Set $this->bootstrap to true if your module is compliant with bootstrap (PrestaShop 1.6)
         */
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Popup shipping rules button');
        $this->description = $this->l('This module show a button in product page to a reminder for shipping rules');
        $this->confirmUninstall = $this->l('Are you sure you want uninstall this module?');
        $this->ps_versions_compliancy = array('min' => '1.6', 'max' => _PS_VERSION_);
        $this->smarty = Context::getContext()->smarty;
        $this->link = new LinkCore();
    }

    /**
     * Don't forget to create update methods if needed:
     * http://doc.prestashop.com/display/PS16/Enabling+the+Auto-Update
     */
    public function install()
    {
        return parent::install() &&
            $this->registerHook('header') &&
            $this->registerHook('backOfficeHeader') &&
            $this->registerHook('displayRightColumnProduct') &&
            $this->registerHook('displayProductButtons') &&
            $this->installSql();
    }
    
    public function installSql()
    {
        $db = Db::getInstance();
        $sql = array();
        
        $sql[] = 'CREATE TABLE IF NOT EXISTS ' . _DB_PREFIX_ . 'mp_shippingbutton_messages ( '
            . '`id_message` INT NOT NULL AUTO_INCREMENT , '
            . '`id_supplier` INT NOT NULL , '
            . '`id_lang` INT NOT NULL , '
            . '`message` TEXT NOT NULL , '
            . 'PRIMARY KEY (`id_message`), '
            . 'UNIQUE `idx_id_supplier_message` (`id_supplier`, `id_lang`)) '
            . 'ENGINE = InnoDB;';
                                    
            foreach ($sql as $query) {
                if ($db->execute($query) == false) {
                    $this->_errors[] = sprintf($this->l('Error %s during table creation.'),$db->getMsgError()); 
                }
            }
    }
    
    public function uninstall()
    {
        return parent::uninstall();
    }

    /**
    * Add the CSS & JavaScript files you want to be loaded in the BO.
    */
    public function hookBackOfficeHeader()
    {
        if (Tools::getValue('module_name') == $this->name) {
            $this->context->controller->addJS($this->_path.'views/js/back.js');
            $this->context->controller->addCSS($this->_path.'views/css/back.css');
        }
    }

    /**
     * Add the CSS & JavaScript files you want to be added on the FO.
     */
    public function hookHeader()
    {
        $this->context->controller->addJquery();
        $this->context->controller->addCSS($this->_path.'/views/css/front.css');
    }
    
    public function hookDisplayProductButtons()
    {
        $link = new Link();
        $id_lang = (int)Context::getContext()->language->id;
        $id_product = (int)Tools::getValue('id_product');
        $product = new Product($id_product);
        $id_supplier = $product->id_supplier; 
        
        $db = Db::getInstance();
        $sql = new DbQueryCore();
        $sql->select('message')
        ->from('mp_shippingbutton_messages')
        ->where('id_supplier=' . (int)$id_supplier)
        ->where('id_lang=' . (int)$id_lang);
        $row = $db->getValue($sql);
        if (!$row) {
            $sql = new DbQueryCore();
            $sql->select('message')
            ->from('mp_shippingbutton_messages')
            ->where('id_supplier=0')
            ->where('id_lang=' . (int)$id_lang);
            $row = $db->getValue($sql);
            if (!$row) {
                $html_content = '';
            } else {
                $html_content = $this->decodeMessage($row);
            }
        } else {
            $html_content = $this->decodeMessage($row);
        }
        
        //$token = Tools::getAdminTokenLite('AdminModules');
        $url = str_replace('/module/', '/modules/', $link->getModuleLink($this->name, 'ajaxDisplayProductAvailability.php'));
        
        $this->smarty->assign(
            array(
                'id_product' => $id_product,
                'url' => $url,
                //'token' => $token,
                'html_content' => $html_content,
            )
        );
        return $this->smarty->fetch(dirname(__FILE__) . '/views/templates/front/displayRightColumnButton.tpl');
    }
    
    public function hookDisplayRightColumnProduct()
    {
        $link = new Link();
        $id_lang = (int)Context::getContext()->language->id;
        $id_product = (int)Tools::getValue('id_product');
        $product = new Product($id_product);
        $id_supplier = $product->id_supplier; 
        
        $db = Db::getInstance();
        $sql = new DbQueryCore();
        $sql->select('message')
        ->from('mp_shippingbutton_messages')
        ->where('id_supplier=' . (int)$id_supplier)
        ->where('id_lang=' . (int)$id_lang);
        $row = $db->getValue($sql);
        if (!$row) {
            $sql = new DbQueryCore();
            $sql->select('message')
            ->from('mp_shippingbutton_messages')
            ->where('id_supplier=0')
            ->where('id_lang=' . (int)$id_lang);
            $row = $db->getValue($sql);
            if (!$row) {
                $html_content = '';
            } else {
                $html_content = $this->decodeMessage($row);
            }
        } else {
            $html_content = $this->decodeMessage($row);
        }
        
        //$token = Tools::getAdminTokenLite('AdminModules');
        $url = str_replace('/module/', '/modules/', $link->getModuleLink($this->name, 'ajaxDisplayProductAvailability.php'));
        
        $this->smarty->assign(
            array(
                'id_product' => $id_product,
                'url' => $url,
                //'token' => $token,
                'html_content' => $html_content,
            )
        );
        return $this->smarty->fetch(dirname(__FILE__) . '/views/templates/front/displayRightColumnButton.tpl');
    }
    
    public function getContent()
    {
        $confirmation = array();
        if (Tools::isSubmit('submitMessage')) {
            $res = $this->saveMessage();
            if ($res) {
                $confirmation[] = $res;
            }
        }
        
        $id_lang = Context::getContext()->language->id;
        $link = new LinkCore();
        $token = Tools::getAdminTokenLite('AdminModules');
        $iso = $this->context->language->iso_code;
        $this->tpl_vars['iso'] = file_exists(_PS_CORE_DIR_.'/js/tiny_mce/langs/'.$iso.'.js') ? $iso : 'en';
        $this->tpl_vars['path_css'] = _THEME_CSS_DIR_;
        $this->tpl_vars['ad'] = __PS_BASE_URI__.basename(_PS_ADMIN_DIR_);
        $this->tpl_vars['tinymce'] = true;
        
        $this->context->controller->addJS(_PS_JS_DIR_.'tiny_mce/tiny_mce.js');
        $this->context->controller->addJS(_PS_JS_DIR_.'admin/tinymce.inc.js');
        
        $db = Db::getInstance();
        $sql = new DbQueryCore();
        $sql->select('sm.*')
            ->select('s.name')
            ->from('mp_shippingbutton_messages', 'sm')
            ->innerJoin('supplier','s','s.id_supplier=sm.id_supplier')
            ->orderBy('s.name');
        
        $messages = $db->executeS($sql);
        
        Context::getContext()->smarty->assign(
            array(
                'iso' => file_exists(_PS_CORE_DIR_.'/js/tiny_mce/langs/'.$iso.'.js') ? $iso : 'en',
                'path_css' => _THEME_CSS_DIR_,
                'ad' => __PS_BASE_URI__.basename(_PS_ADMIN_DIR_),
                'tinymce' => true,
                'form_link' => $link->getAdminLink('AdminModules',false),
                'token' => $token,
                'configure' => $this->name,
                'suppliers' => SupplierCore::getSuppliers(false,$id_lang),
                'messages' => $messages,
            )
        );
        return implode('<br>',$confirmation) 
            . $this->smarty->fetch(dirname(__FILE__) . '/views/templates/admin/configuration.tpl');
    }
    
    public function ajaxProcessChangeSupplier()
    {
        $id_supplier = (int)Tools::getValue('id_supplier',0);
        $id_lang = (int)Context::getContext()->language->id;
        $message = $this->decodeMessage($this->getMessage($id_supplier,$id_lang));
        
        print $message;
        exit();
    }
    
    public function getMessage($id_supplier, $id_lang)
    {
        $db = Db::getInstance();
        $sql = new DbQueryCore();
        $sql->select('message')
        ->from('mp_shippingbutton_messages')
        ->where('id_lang=' . (int)$id_lang)
        ->where('id_supplier=' . (int)$id_supplier);
        $message = $db->getValue($sql);
        if(!$message) {
            return '';
        }
        return $message;
    }
    
    public function saveMessage()
    {
        $id_lang = (int)Context::getContext()->language->id;
        $id_supplier = (int)Tools::getValue('input_select_supplier',0);
        $message = $this->encodeMessage(Tools::getValue('content_html',''));
        
        if ($message) {
            $db = Db::getInstance();
            $sql = new DbQueryCore();
            
            $sql->select('count(*)')
            ->from('mp_shippingbutton_messages')
            ->where('id_lang=' . (int)$id_lang)
            ->where('id_supplier=' . (int)$id_supplier);
            $exists = (int)$db->getValue($sql);
            if ($exists) {
                $res = $db->update(
                    'mp_shippingbutton_messages',
                    array(
                        'id_lang' => (int)$id_lang,
                        'id_supplier' => (int)$id_supplier,
                        'message' => pSQL($message),
                    ),
                    'id_lang = ' . (int)$id_lang . ' and id_supplier = ' . (int)$id_supplier
                );
                if (!$res) {
                    $this->_errors[] = sprintf($this->l('Message not saved. Error: %s'), $db->getMsgError());
                    return false;
                } else {
                    return $this->displayConfirmation($this->l('Message updated.'));
                }
            } else {
                $res = $db->insert(
                    'mp_shippingbutton_messages',
                    array(
                        'id_lang' => (int)$id_lang,
                        'id_supplier' => (int)$id_supplier,
                        'message' => pSQL($message),
                    ));
                if (!$res) {
                    $this->_errors[] = sprintf($this->l('Message not saved. Error: %s'), $db->getMsgError());
                    return false;
                } else {
                    return $this->displayConfirmation($this->l('Message saved.'));
                }
            }
        } else {
            $this->_errors[] = $this->l('No message to save.');
        }
    }
    
    public function encodeMessage($message)
    {
        return htmlentities(htmlspecialchars($message));
    }
    
    public function decodeMessage($message)
    {
        return html_entity_decode(htmlspecialchars_decode($message));
    }
}
