<?php

namespace Tualo\Office\FibuConv\Routes;

use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Tualo\Office\DS;

class RemoveBOM extends \Tualo\Office\Basic\RouteWrapper
{

    public static function removeUTF8BOM($string)
    {
        if (substr($string, 0, 3) === "\xEF\xBB\xBF") {
            $string = substr($string, 3);
        }
        return $string;
    }

    public static function register()
    {


        BasicRoute::add('/fibuconv/removebom', function () {

            $db = App::get('session')->getDB();
            if ($db == NULL) {
                App::result('msg', 'Nicht erlaubt');
            } else {


                $files = $db->direct('select * from fibufiles where typ="paypal-pure"    ');

                foreach ($files as $file) {
                    $data = \Tualo\Office\DS\DSFiles::instance('fibufiles')->getBase64('id', $file['id']);
                    list($mime, $d) = explode('base64,', $data);
                    $d = base64_decode($d);


                    $db->direct('update ds_files_data set data={data} where file_id = {file_id}', [
                        'file_id' => $file['file_id'],
                        'data' => $mime . 'base64,' . base64_encode(self::removeUTF8BOM($d))
                    ]);

                    $db->direct("update fibufiles set typ = 'paypal-pc' where id = {id}", ['id' => $file['id']]);
                }

                App::result('success', true);
            }

            App::contenttype('application/json');
        }, ['get', 'post'], true);
    }
}
