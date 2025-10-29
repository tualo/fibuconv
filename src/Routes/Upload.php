<?php

namespace Tualo\Office\FibuConv\Routes;

use Tualo\Office\Basic\TualoApplication as App;
use Tualo\Office\Basic\Route as BasicRoute;
use Tualo\Office\Basic\IRoute;
use Ramsey\Uuid\Uuid;

class Upload extends \Tualo\Office\Basic\RouteWrapper
{

    public static function register()
    {

        BasicRoute::add('/fibuconv/upload', function () {

            $db = App::get('session')->getDB();
            if ($db == NULL) {
                App::result('msg', 'Nicht erlaubt');
            } else {

                function error2txt($error)
                {
                    switch ($error) {
                        case UPLOAD_ERR_INI_SIZE:
                            return "UPLOAD_ERR_INI_SIZE: Die Datei ist zu gro&szlig";
                            break;
                        case UPLOAD_ERR_FORM_SIZE:
                            return "UPLOAD_ERR_FORM_SIZE: Die Datei ist zu gro&szlig";
                            break;
                        case UPLOAD_ERR_PARTIAL:
                            return "UPLOAD_ERR_PARTIAL: Die Datei wurde nur teilweise hochgeladen";
                            break;
                        case UPLOAD_ERR_NO_FILE:
                            return "UPLOAD_ERR_NO_FILE: Es wurde keine Datei hochgeladen";
                            break;
                        case 0:
                            return " ";
                            break;
                        default:
                            return "Unbekannter Fehler";
                            break;
                    }
                }

                $error = "";
                if (isset($_FILES['file'])) {
                    $sfile = $_FILES['file']['tmp_name'];
                    $name = $_FILES['file']['name'];
                    $extension = pathinfo($name, PATHINFO_EXTENSION);
                    $type = $_FILES['file']['type'];
                    $error = $_FILES['file']['error'];
                    if ($error == UPLOAD_ERR_OK) {
                        $tempname = '.ht_' . ((Uuid::uuid4())->toString());
                        $temppath = App::get('tempPath');
                        if (file_exists($temppath . '/' . $tempname . '.' . $extension)) {
                            unlink($temppath . '/' . $tempname . '.' . $extension);
                        }
                        move_uploaded_file($sfile, $temppath . '/' . $tempname . '.' . $extension);

                        $filecontent = file_get_contents($temppath . '/' . $tempname . '.' . $extension);
                        $checksum = md5($filecontent);
                        if ($db->singleValue('select id from fibuconv_uploaded_files where `checksum`={checksum}', array('checksum' => $checksum), 'id') === false) {
                            $uuid = $db->singleValue('select uuid() uuid', array(), 'uuid');
                            $db->direct('insert into fibuconv_uploaded_files (
                                `id`,
                                `filename`,
                                `pathname`,
                                `processed`,
                                `processed_datetime`,
                                `upload_datetime`,
                                `filesize`,
                                `extension`,
                                `checksum`,
                                `login`
                            ) values (
                                {uuid},
                                {filename},
                                {pathname},
                                0,
                                null,
                                now(),
                                {filesize},
                                {extension},
                                {checksum},
                                getSessionUser()
                            )', array(
                                'uuid'        =>    $uuid,
                                'filename'    =>    $name,
                                'pathname'    =>    '/uploads',
                                'filesize'    =>    strlen($filecontent),
                                'extension'    =>    $extension,
                                'checksum'    =>    $checksum
                            ));
                            $db->direct('insert into fibuconv_uploaded_files_data (id,data) values ({id},{data})', array('id' => $uuid, 'data' => base64_encode($filecontent)));
                            App::result('success', true);
                        } else {
                            App::result('msg', 'Die Datei wurde bereits hochgeladen');
                        }


                        if (file_exists($temppath . '/' . $tempname . '.' . $extension)) {
                            unlink($temppath . '/' . $tempname . '.' . $extension);
                        }
                    } else {
                        App::result('msg', error2txt($error));
                    }
                }
            }

            App::contenttype('application/json');
        }, ['get', 'post'], true);
    }
}
