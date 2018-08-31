<html>
<?php


$path = "127.0.0.1/5000/search/" . $name_to_cts[$_GET["target"]] . "/" . $name_to_cts[$_GET["source"]];

header("Location: " . $path);

$name_to_cts = ["ambrose.apologia_david_altera" => "urn:cts:latinLit:stoa0022.stoa014",
"ambrose.de_apologia_david" => "urn:cts:latinLit:stoa0022.stoa015",
"ambrose.de_cain" => "urn:cts:latinLit:stoa0022.stoa021",
"ambrose.de_fuga_saeculi" => "urn:cts:latinLit:stoa0022.stoa029",
"ambrose.de_helia_et_ieiunio" => "urn:cts:latinLit:stoa0022.stoa025",
"ambrose.de_iacob" => "urn:cts:latinLit:stoa0022.stoa034",
"ambrose.de_interpellatione_iob_et_david" => "urn:cts:latinLit:stoa0022.stoa032",
"ambrose.de_ioseph" => "urn:cts:latinLit:stoa0022.stoa035",
"ambrose.de_nabuthae" => "urn:cts:latinLit:stoa0022.stoa038",
"ambrose.de_noe" => "urn:cts:latinLit:stoa0022.stoa039",
"ambrose.de_paradiso" => "urn:cts:latinLit:stoa0022.stoa042",
"ambrose.de_patriarchis" => "urn:cts:latinLit:stoa0022.stoa019",
"ambrose.de_tobia" => "urn:cts:latinLit:stoa0022.stoa044",
"ambrose.exlanatio_super_psalmos_xii" => "urn:cts:latinLit:stoa0022.stoa048",
"ambrose.expositio_de_psalmo_cxviii" => "urn:cts:latinLit:stoa0022.stoa052",
"ambrose.expositio_evangelii_secundum_lucan" => "urn:cts:latinLit:stoa0022.stoa051",
"ambrose.hexameron" => "urn:cts:latinLit:stoa0022.stoa054",
"ammianus.rerum_gestarum" => "urn:cts:latinLit:stoa0023.stoa001",
"apuleius.apologia" => "urn:cts:latinLit:phi1212.phi001",
"apuleius.de_deo_socratis" => "urn:cts:latinLit:phi1212.phi004",
"apuleius.florida" => "urn:cts:latinLit:phi1212.phi003",
"apuleius.metamorphoses" => "urn:cts:latinLit:phi1212.phi002",
"aristotle.economics_book_3" => "urn:cts:greekLit:tlg0086.tlg029",
"arnobius.adversus_nationes" => "urn:cts:latinLit:stoa0034.stoa001",
"augustine.adnotationes_in_iob" => "urn:cts:latinLit:stoa0040.stoa001a",
"augustine.breviculus_collationis_cum_donatistis" => "urn:cts:latinLit:stoa0040.stoa014a",
"augustine.commonitorium" => "urn:cts:latinLit:stoa0040.stoa015b",
"augustine.confessions" => "urn:cts:latinLit:stoa0040.stoa001",
"augustine.contra_academicos" => "urn:cts:latinLit:stoa0040.stoa016",
"augustine.contra_adimantum" => "urn:cts:latinLit:stoa0040.stoa017",
"augustine.contra_cresconium_grammaticum_et_donatistam" => "urn:cts:latinLit:stoa0040.stoa019",
"augustine.contra_duas_epistulas_pelagianorum" => "urn:cts:latinLit:stoa0040.stoa021",
"augustine.contra_epistulam_fundamenti" => "urn:cts:latinLit:stoa0040.stoa021a",
"augustine.contra_epistulam_parmeniani" => "urn:cts:latinLit:stoa0040.stoa023",
"augustine.contra_faustum" => "urn:cts:latinLit:stoa0040.stoa024",
"augustine.contra_felicem" => "urn:cts:latinLit:stoa0040.stoa031a",
"augustine.contra_fortunatum" => "urn:cts:latinLit:stoa0040.stoa024b",
"augustine.contra_gaudentium_donatistarum_episcopum" => "urn:cts:latinLit:stoa0040.stoa025",
"augustine.contra_litteras_petiliani" => "urn:cts:latinLit:stoa0040.stoa027",
"augustine.contra_mendacium" => "urn:cts:latinLit:stoa0040.stoa029",
"augustine.contra_partem_donati_post_gesta" => "urn:cts:latinLit:stoa0040.stoa029a",
"augustine.contra_secundinum" => "urn:cts:latinLit:stoa0040.stoa031",
"augustine.de_adulterinis_coniugiis" => "urn:cts:latinLit:stoa0040.stoa036",
"augustine.de_agone_christiano" => "urn:cts:latinLit:stoa0040.stoa032",
"augustine.de_baptismo" => "urn:cts:latinLit:stoa0040.stoa033a",
"augustine.de_beata_vita" => "urn:cts:latinLit:stoa0040.stoa034",
"augustine.de_bono_coniugali" => "urn:cts:latinLit:stoa0040.stoa035",
"augustine.de_bono_viduitatis" => "urn:cts:latinLit:stoa0040.stoa035a",
"augustine.de_civitate_dei" => "urn:cts:latinLit:stoa0040.stoa003",
"augustine.de_consensu_evangelistarum" => "urn:cts:latinLit:stoa0040.stoa037",
"augustine.de_continentia" => "urn:cts:latinLit:stoa0040.stoa037a",
"augustine.de_cura_pro_mortuis_gerenda" => "urn:cts:latinLit:stoa0040.stoa037c",
"augustine.de_divinatione_daemonum" => "urn:cts:latinLit:stoa0040.stoa038a",
"augustine.de_duabus_animabus" => "urn:cts:latinLit:stoa0040.stoa040",
"augustine.de_fide_et_operibus" => "urn:cts:latinLit:stoa0040.stoa041",
"augustine.de_fide_et_symbolo" => "urn:cts:latinLit:stoa0040.stoa006",
"augustine.de_genesi_ad_litteram" => "urn:cts:latinLit:stoa0040.stoa042a",
"augustine.de_genesi_ad_litteram_liber_imperfectus" => "urn:cts:latinLit:stoa0040.stoa042",
"augustine.de_gestis_pelagii" => "urn:cts:latinLit:stoa0040.stoa044",
"augustine.de_gratia_christi" => "urn:cts:latinLit:stoa0040.stoa046",
"augustine.de_mendacio" => "urn:cts:latinLit:stoa0040.stoa050",
"augustine.de_natura_boni" => "urn:cts:latinLit:stoa0040.stoa053",
"augustine.de_natura_et_gratia" => "urn:cts:latinLit:stoa0040.stoa054",
"augustine.de_natura_et_origine_animae" => "urn:cts:latinLit:stoa0040.stoa033",
"augustine.de_nuptiis_et_concupiscentia" => "urn:cts:latinLit:stoa0040.stoa056a",
"augustine.de_opere_monachorum" => "urn:cts:latinLit:stoa0040.stoa055",
"augustine.de_ordine" => "urn:cts:latinLit:stoa0040.stoa056",
"augustine.de_patientia" => "urn:cts:latinLit:stoa0040.stoa056b",
"augustine.de_peccato_originali" => "urn:cts:latinLit:stoa0040.stoa056c",
"augustine.de_peccatorum_meritis_et_remissione_et_de_baptismo_parvulorum" => "urn:cts:latinLit:stoa0040.stoa057",
"augustine.de_perfectione_iustitiae_hominis" => "urn:cts:latinLit:stoa0040.stoa057a",
"augustine.de_sancta_virginitate" => "urn:cts:latinLit:stoa0040.stoa060",
"augustine.de_spiritu_et_littera" => "urn:cts:latinLit:stoa0040.stoa062",
"augustine.de_utilitae_credendi" => "urn:cts:latinLit:stoa0040.stoa064",
"augustine.epistula_ad_catholicos_de_secta_donatistarum" => "urn:cts:latinLit:stoa0040.stoa020",
"augustine.epistulae" => "urn:cts:latinLit:stoa0040.stoa011",
"augustine.gesta_cum_emerito_donatistarum_episcopo" => "urn:cts:latinLit:stoa0040.stoa066c",
"augustine.libellus_adversus_fulgentium_donatistam" => "urn:cts:latinLit:stoa0040.stoa070a",
"augustine.liber_de_unico_baptismo" => "urn:cts:latinLit:stoa0040.stoa063",
"augustine.locutiones_in_heptateuchum" => "urn:cts:latinLit:stoa0040.stoa070",
"augustine.psalmus_contra_partem_donati" => "urn:cts:latinLit:stoa0040.stoa072",
"augustine.quaestiones_in_heptateuchum" => "urn:cts:latinLit:stoa0040.stoa074",
"augustine.retractationes" => "urn:cts:latinLit:stoa0040.stoa077",
"augustine.sermo_ad_caesariensis_ecclesiae_plebem" => "urn:cts:latinLit:stoa0040.stoa077c",
"augustine.sermo_de_rusticiano_subdiacono" => "urn:cts:latinLit:stoa0040.stoa077d",
"augustine.speculum" => "urn:cts:latinLit:stoa0040.stoa080a",
"augustine_pseudo.quaestiones_veteris_et_novi_testamenti" => "urn:cts:latinLit:stoa0040a.stoa002",
"aurelius_victor.de_caesaribus" => "urn:cts:latinLit:stoa0043.stoa001",
"aurelius_victor.epitome_de_caesaribus" => "urn:cts:latinLit:stoa0044.stoa003",
"ausonius.cento_nuptialis" => "urn:cts:latinLit:stoa0045.stoa003",
"ausonius.commemoratio_professorum_burdigalensium" => "urn:cts:latinLit:stoa0045.stoa004",
"ausonius.cupido_cruciatus" => "urn:cts:latinLit:stoa0045.stoa005",
"ausonius.de_bissula" => "urn:cts:latinLit:stoa0045.stoa001",
"ausonius.de_herediolo" => "urn:cts:latinLit:stoa0045.stoa006",
"ausonius.de_xii_caesaribus" => "urn:cts:latinLit:stoa0045.stoa002",
"ausonius.eclogarum_liber" => "urn:cts:latinLit:stoa0045.stoa007",
"ausonius.ephemeris_id_est_totius_diei_negotium" => "urn:cts:latinLit:stoa0045.stoa008",
"ausonius.epicedion_in_patrem" => "urn:cts:latinLit:stoa0045.stoa009",
"ausonius.epigrammata_ausonii_de_diversis_rebus" => "urn:cts:latinLit:stoa0045.stoa010",
"ausonius.epistularum" => "urn:cts:latinLit:stoa0045.stoa011",
"ausonius.epitaphia_heroum_qui_bello_troico_interfuerunt" => "urn:cts:latinLit:stoa0045.stoa012",
"ausonius.gratiarum_actio" => "urn:cts:latinLit:stoa0045.stoa014",
"ausonius.griphus_ternarii_numeri" => "urn:cts:latinLit:stoa0045.stoa015",
"ausonius.libri_de_fastis_conclusio" => "urn:cts:latinLit:stoa0045.stoa017",
"ausonius.ludus_septem_sapientum" => "urn:cts:latinLit:stoa0045.stoa018",
"ausonius.mosella" => "urn:cts:latinLit:stoa0045.stoa019",
"ausonius.oratio_consulis_ausonii_versibus_rhopalicis" => "urn:cts:latinLit:stoa0045.stoa020",
"ausonius.ordo_urbium_nobilium" => "urn:cts:latinLit:stoa0045.stoa021",
"ausonius.parentalia" => "urn:cts:latinLit:stoa0045.stoa022",
"ausonius.praefatiunculae" => "urn:cts:latinLit:stoa0045.stoa025",
"ausonius.precationes" => "urn:cts:latinLit:stoa0045.stoa026",
"ausonius.technopaegnion" => "urn:cts:latinLit:stoa0045.stoa028",
"ausonius.versus_paschales_pro_augusto_dicti" => "urn:cts:latinLit:stoa0045.stoa027",
"bede.historiam_ecclesiasticam_gentis_anglorum" => "urn:cts:latinLit:stoa0054.stoa006",
"boethius.consolatio_philosophiae" => "urn:cts:latinLit:stoa0058.stoa001",
"boethius.de_fide_catholica" => "urn:cts:latinLit:stoa0058.stoa006",
"boethius.liber_de_persona_et_duabus_naturis_contra_eutychen_et_nestorium" => "urn:cts:latinLit:stoa0058.stoa023",
"boethius.quomodo_substantiae_in_eo_quod_sint_bonae_sint_cum_non_sint_substantialia_bona" => "urn:cts:latinLit:stoa0058.stoa003",
"boethius.quomodo_trinitas" => "urn:cts:latinLit:stoa0058.stoa025",
"boethius.utrum_pater" => "urn:cts:latinLit:stoa0058.stoa028",
"caesar.de_bello_civili" => "urn:cts:latinLit:phi0448.phi002",
"caesar.de_bello_gallico" => "urn:cts:latinLit:phi0448.phi001",
"caesar_augustus.res_gestae_divi_augusti" => "urn:cts:latinLit:phi1221.phi007",
"catullus.carmina" => "urn:cts:latinLit:phi0472.phi001",
"celsus.de_medicina" => "urn:cts:latinLit:phi0836.phi002",
"cicero.academica" => "urn:cts:latinLit:phi0474.phi045",
"cicero.brutus" => "urn:cts:latinLit:phi0474.phi039",
"cicero.cum_populo_gratias_egit" => "urn:cts:latinLit:phi0474.phi018",
"cicero.de_amicitia" => "urn:cts:latinLit:phi0474.phi052",
"cicero.de_divinatione" => "urn:cts:latinLit:phi0474.phi053",
"cicero.de_domo_sua" => "urn:cts:latinLit:phi0474.phi020",
"cicero.de_fato" => "urn:cts:latinLit:phi0474.phi054",
"cicero.de_finibus_bonorum_et_malorum" => "urn:cts:latinLit:phi0474.phi048",
"cicero.de_haruspicum_responso" => "urn:cts:latinLit:phi0474.phi021",
"cicero.de_imperio_cn_pompei" => "urn:cts:latinLit:phi0474.phi009",
"cicero.de_inventione" => "urn:cts:latinLit:phi0474.phi036",
"cicero.de_lege_agraria_contra_rullum" => "urn:cts:latinLit:phi0474.phi011",
"cicero.de_natura_deorum" => "urn:cts:latinLit:phi0474.phi050",
"cicero.de_officiis" => "urn:cts:latinLit:phi0474.phi055",
"cicero.de_optimo_genere_oratorum" => "urn:cts:latinLit:phi0474.phi041",
"cicero.de_oratore" => "urn:cts:latinLit:phi0474.phi037",
"cicero.de_partitione_oratoria" => "urn:cts:latinLit:phi0474.phi038",
"cicero.de_provinciis_consularibus" => "urn:cts:latinLit:phi0474.phi025",
"cicero.de_republica" => "urn:cts:latinLit:phi0474.phi043",
"cicero.de_senectute" => "urn:cts:latinLit:phi0474.phi051",
"cicero.divinatio_in_c_verrem" => "urn:cts:latinLit:phi0474.phi005",
"cicero.divinatio_in_q_caecilium" => "urn:cts:latinLit:phi0474.phi004",
"cicero.epistulae_ad_familiares" => "urn:cts:latinLit:phi0474.phi056",
"cicero.in_catilinam" => "urn:cts:latinLit:phi0474.phi013",
"cicero.in_l_pisonem" => "urn:cts:latinLit:phi0474.phi027",
"cicero.in_vatinium" => "urn:cts:latinLit:phi0474.phi023",
"cicero.letters_to_atticus" => "urn:cts:latinLit:phi0474.phi057",
"cicero.letters_to_brutus" => "urn:cts:latinLit:phi0474.phi059",
"cicero.letters_to_quintus" => "urn:cts:latinLit:phi0474.phi058",
"cicero.lucullus" => "urn:cts:latinLit:phi0474.phi046",
"cicero.orator" => "urn:cts:latinLit:phi0474.phi040",
"cicero.paradoxa_stoicorum_ad_m_brutum" => "urn:cts:latinLit:phi0474.phi047",
"cicero.philippicae" => "urn:cts:latinLit:phi0474.phi035",
"cicero.post_reditum_in_senatu" => "urn:cts:latinLit:phi0474.phi019",
"cicero.pro_a_caecina" => "urn:cts:latinLit:phi0474.phi008",
"cicero.pro_a_cluentio" => "urn:cts:latinLit:phi0474.phi010",
"cicero.pro_archia" => "urn:cts:latinLit:phi0474.phi016",
"cicero.pro_balbo" => "urn:cts:latinLit:phi0474.phi026",
"cicero.pro_c_rabirio" => "urn:cts:latinLit:phi0474.phi012",
"cicero.pro_c_rabirio_postumo" => "urn:cts:latinLit:phi0474.phi030",
"cicero.pro_fonteio" => "urn:cts:latinLit:phi0474.phi007",
"cicero.pro_l_flacco" => "urn:cts:latinLit:phi0474.phi017",
"cicero.pro_ligario" => "urn:cts:latinLit:phi0474.phi033",
"cicero.pro_m_caelio" => "urn:cts:latinLit:phi0474.phi024",
"cicero.pro_marcello" => "urn:cts:latinLit:phi0474.phi032",
"cicero.pro_milone" => "urn:cts:latinLit:phi0474.phi031",
"cicero.pro_murena" => "urn:cts:latinLit:phi0474.phi014",
"cicero.pro_plancio" => "urn:cts:latinLit:phi0474.phi028",
"cicero.pro_publio_quinctio" => "urn:cts:latinLit:phi0474.phi001",
"cicero.pro_q_roscio_comoedo" => "urn:cts:latinLit:phi0474.phi003",
"cicero.pro_rege_deiotaro" => "urn:cts:latinLit:phi0474.phi034",
"cicero.pro_s_roscio" => "urn:cts:latinLit:phi0474.phi002",
"cicero.pro_scauro" => "urn:cts:latinLit:phi0474.phi029",
"cicero.pro_sestio" => "urn:cts:latinLit:phi0474.phi022",
"cicero.pro_sulla" => "urn:cts:latinLit:phi0474.phi015",
"cicero.pro_tullio" => "urn:cts:latinLit:phi0474.phi006",
"cicero.timaeus" => "urn:cts:latinLit:phi0474.phi072",
"cicero.topica" => "urn:cts:latinLit:phi0474.phi042",
"cicero.tusculanae_disputationes" => "urn:cts:latinLit:phi0474.phi049",
"claudian.carmina_minora" => "urn:cts:latinLit:stoa0089.stoa001a",
"claudian.de_bello_gildonico" => "urn:cts:latinLit:stoa0089.stoa002",
"claudian.de_bello_gothico" => "urn:cts:latinLit:stoa0089.stoa003",
"claudian.de_consulatu_stilichonis" => "urn:cts:latinLit:stoa0089.stoa004",
"claudian.de_raptu_proserpinae" => "urn:cts:latinLit:stoa0089.stoa005",
"claudian.epithalamium_de_nuptiis_honorii_augusti" => "urn:cts:latinLit:stoa0089.stoa006",
"claudian.in_consulatum_olybrii_et_probini" => "urn:cts:latinLit:stoa0089.stoa014",
"claudian.in_eutropium" => "urn:cts:latinLit:stoa0089.stoa008",
"claudian.in_rufinum" => "urn:cts:latinLit:stoa0089.stoa009",
"claudian.panegyricus_de_quarto_consulatu_honorii_augusti" => "urn:cts:latinLit:stoa0089.stoa011",
"claudian.panegyricus_de_sexto_consulatu_honorii_augusti" => "urn:cts:latinLit:stoa0089.stoa012",
"claudian.panegyricus_de_tertio_consulatu_honorii_augusti" => "urn:cts:latinLit:stoa0089.stoa010",
"claudian.panegyricus_dictus_manlio_theodoro_consuli" => "urn:cts:latinLit:stoa0089.stoa013",
"claudius_mamertinus.panegyricus" => "urn:cts:latinLit:stoa0187b.stoa001",
"columella.de_re_rustica" => "urn:cts:latinLit:phi0845.phi002",
"commodian.carmen_apologeticum" => "urn:cts:latinLit:stoa0096.stoa004",
"commodian.instructiones" => "urn:cts:latinLit:stoa0096.stoa003",
"curtius_rufus.historiae_alexandri_magni" => "urn:cts:latinLit:phi0860.phi001",
"cyprian.ad_demetrianum" => "urn:cts:latinLit:stoa0104a.stoa002",
"cyprian.ad_donatum" => "urn:cts:latinLit:stoa0104a.stoa001",
"cyprian.ad_quirinum_aut_testimoniorum_libri_tres_adversus_judaeos" => "urn:cts:latinLit:stoa0104a.stoa014",
"cyprian.de_bono_patientiae" => "urn:cts:latinLit:stoa0104a.stoa003",
"cyprian.de_catholicae_ecclesiae_unitate" => "urn:cts:latinLit:stoa0104a.stoa010",
"cyprian.de_dominica_oratione" => "urn:cts:latinLit:stoa0104a.stoa015",
"cyprian.de_habitu_uirginum" => "urn:cts:latinLit:stoa0104a.stoa004",
"cyprian.de_lapsis" => "urn:cts:latinLit:stoa0104a.stoa007",
"cyprian.de_mortalitate" => "urn:cts:latinLit:stoa0104a.stoa008",
"cyprian.de_opere_et_eleemosynis" => "urn:cts:latinLit:stoa0104a.stoa009",
"cyprian.de_zelo_et_livore" => "urn:cts:latinLit:stoa0104a.stoa011",
"cyprian.epistulae" => "urn:cts:latinLit:stoa0104a.stoa012",
"cyprian.fortunatum_aut_de_exhortatione_martyrii" => "urn:cts:latinLit:stoa0104a.stoa005",
"cyprian.quod_idola_dii_non_sint" => "urn:cts:latinLit:stoa0104a.stoa006",
"cyprian.sententiae_episcoporum_numero_LXXXVII_de_haereticis_baptizandis" => "urn:cts:latinLit:stoa0104a.stoa013",
"cyprian_pseudo.ad_flavium_felicem_de_resurrectione_mortuorum" => "urn:cts:latinLit:stoa0104p.stoa003",
"cyprian_pseudo.ad_novatianum" => "urn:cts:latinLit:stoa0104p.stoa001",
"cyprian_pseudo.ad_senatorem_ex_christiana_religione_ad_idolorum_servitutem_conversum" => "urn:cts:latinLit:stoa0104p.stoa003",
"cyprian_pseudo.ad_vigilium_de_iudaica_incredulitate" => "urn:cts:latinLit:stoa0104p.stoa002",
"cyprian_pseudo.adversus_iudaeos" => "urn:cts:latinLit:stoa0104p.stoa020",
"cyprian_pseudo.de_aleatoribus" => "urn:cts:latinLit:stoa0104p.stoa018",
"cyprian_pseudo.de_bono_pudicitiae" => "urn:cts:latinLit:stoa0104p.stoa005",
"cyprian_pseudo.de_duodecim_abusivis_saeculi" => "urn:cts:latinLit:stoa0104p.stoa014",
"cyprian_pseudo.de_duplici_martyrio" => "urn:cts:latinLit:stoa0104p.stoa006",
"cyprian_pseudo.de_iona" => "urn:cts:latinLit:stoa0104p.stoa003",
"cyprian_pseudo.de_laude_martyrii" => "urn:cts:latinLit:stoa0104p.stoa007",
"cyprian_pseudo.de_montibus_sina_et_sion" => "urn:cts:latinLit:stoa0104p.stoa008",
"cyprian_pseudo.de_pascha" => "urn:cts:latinLit:stoa0104p.stoa003",
"cyprian_pseudo.de_pascha_computus" => "urn:cts:latinLit:stoa0104p.stoa009",
"cyprian_pseudo.de_rebaptismate" => "urn:cts:latinLit:stoa0104p.stoa010",
"cyprian_pseudo.de_singularitate_clericorum" => "urn:cts:latinLit:stoa0104p.stoa011",
"cyprian_pseudo.de_spectaculis" => "urn:cts:latinLit:stoa0104p.stoa013",
"cyprian_pseudo.epistulae" => "urn:cts:latinLit:stoa0104p.stoa016",
"cyprian_pseudo.genesis" => "urn:cts:latinLit:stoa0104p.stoa003",
"cyprian_pseudo.orationes" => "urn:cts:latinLit:stoa0104p.stoa019; urn:cts:latinLit:stoa0104p.stoa015",
"cyprian_pseudo.sodoma" => "urn:cts:latinLit:stoa0104p.stoa003",
"cyprianus_gallus.heptateuchos" => "urn:cts:latinLit:stoa0104c.stoa001",
"dracontius.de_laudibus_dei" => "urn:cts:latinLit:stoa0110b.stoa002",
"dracontius.romulea" => "urn:cts:latinLit:stoa0110b.stoa001",
"dracontius.satisfactio" => "urn:cts:latinLit:stoa0110b.stoa004",
"ennius.annales" => "urn:cts:latinLit:phi0043.phi001",
"ennodius.carmina" => "urn:cts:latinLit:stoa0114a.stoa003",
"ennodius.epigrammata" => "urn:cts:latinLit:stoa0114a.stoa009",
"ennodius.epistulae" => "urn:cts:latinLit:stoa0114a.stoa008",
"eugippius.epistula_ad_probam_virginem" => "urn:cts:latinLit:stoa0119.stoa002",
"eugippius.exerpta_ex_operibus_augustini" => "urn:cts:latinLit:stoa0119.stoa003",
"eugippius.vita_sancti_severini" => "urn:cts:latinLit:stoa0119.stoa001",
"eutropius.breviarium" => "urn:cts:latinLit:stoa0121.stoa001",
"evodius.de_fide_contra_manicheos" => "urn:cts:latinLit:stoa0120d.stoa001",
"florus.epitome_bellorum_omnium_annorum" => "urn:cts:latinLit:phi1242.phi001",
"florus.vergilius_orator_an_poeta" => "urn:cts:latinLit:phi1242.phi002",
"gellius.attic_nights" => "urn:cts:latinLit:phi1254.phi001",
"hilary_of_poitiers.fragmenta_historica" => "urn:cts:latinLit:stoa0149b.stoa002",
"hilary_of_poitiers.fragmenta_minora" => "urn:cts:latinLit:stoa0149b.stoa003",
"hilary_of_poitiers.hymni" => "urn:cts:latinLit:stoa0149b.stoa004",
"hilary_of_poitiers.liber_ad_constantium_imperatorem" => "urn:cts:latinLit:stoa0149b.stoa005",
"hilary_of_poitiers.oratio_synodi_sardicensis_ad_constantium_imperatorem" => "urn:cts:latinLit:stoa0149b.stoa007",
"hilary_of_poitiers.tractatus_mysteriorum" => "urn:cts:latinLit:stoa0149b.stoa009",
"hilary_of_poitiers.tractatus_super_psalmos" => "urn:cts:latinLit:stoa0149b.stoa001",
"hilary_of_poitiers_pseudo.ad_leonem_papam" => "urn:cts:latinLit:stoa0149p.stoa003",
"hilary_of_poitiers_pseudo.de_evangelico" => "urn:cts:latinLit:stoa0149p.stoa001",
"hilary_of_poitiers_pseudo.de_martyrio_maccabeorum" => "urn:cts:latinLit:stoa0149p.stoa002",
"hilary_of_poitiers_pseudo.epistula_ad_abram_filiam" => "urn:cts:latinLit:stoa0149b.stoa008",
"hilary_of_poitiers_pseudo.hymni" => "urn:cts:latinLit:stoa0149b.stoa008",
"horace.ars_poetica" => "urn:cts:latinLit:phi0893.phi006",
"horace.carmen_saeculare" => "urn:cts:latinLit:phi0893.phi002",
"horace.epistles" => "urn:cts:latinLit:phi0893.phi005",
"horace.epodes" => "urn:cts:latinLit:phi0893.phi003",
"horace.odes" => "urn:cts:latinLit:phi0893.phi001",
"horace.satires" => "urn:cts:latinLit:phi0893.phi004",
"italicus.ilias_latina" => "urn:cts:latinLit:phi0890.phi001",
"iulius_firmicus_maternus.liber_de_errore_profanorum_religionum" => "urn:cts:latinLit:stoa0123a.stoa001",
"jerome.epistulae" => "urn:cts:latinLit:stoa0162.stoa004",
"jerome.in_hieremiam_prophetam" => "urn:cts:latinLit:stoa0162.stoa024",
"john_cassian.conlationes" => "urn:cts:latinLit:stoa0076c.stoa001",
"john_cassian.de_incarnatione" => "urn:cts:latinLit:stoa0076c.stoa003",
"john_cassian.institutiones" => "urn:cts:latinLit:stoa0076c.stoa002",
"juvenal.satires" => "urn:cts:latinLit:phi1276.phi001",
"juvencus.historia_evangelica" => "urn:cts:latinLit:stoa0169a.stoa002",
"lactantius.carmen_de_passione_domini" => "urn:cts:latinLit:stoa0171.stoa004",
"lactantius.de_ave_phoenice" => "urn:cts:latinLit:stoa0171.stoa001",
"lactantius.de_ira_dei" => "urn:cts:latinLit:stoa0171.stoa006",
"lactantius.de_mortibus_persecutorum" => "urn:cts:latinLit:stoa0171.stoa002",
"lactantius.de_opificio_dei" => "urn:cts:latinLit:stoa0171.stoa007",
"lactantius.divinarum_institutionum" => "urn:cts:latinLit:stoa0171.stoa009",
"lactantius.epitome_divinarum_institutionum" => "urn:cts:latinLit:stoa0171.stoa008",
"livy.ab_urbe_condita" => "urn:cts:latinLit:phi0914.phi001",
"lucan.bellum_civile" => "urn:cts:latinLit:phi0917.phi001",
"lucretius.de_rerum_natura" => "urn:cts:latinLit:phi0550.phi001",
"macrobius.in_somnium_Scipionis_commentarii" => "urn:cts:latinLit:stoa0186.stoa002",
"macrobius.saturnalia" => "urn:cts:latinLit:stoa0186.stoa001",
"manilius.astronomicon" => "urn:cts:latinLit:phi0926.phi001",
"marcus_mincuius_felix.octavius" => "urn:cts:latinLit:stoa0203.stoa001",
"martial.epigrams" => "urn:cts:latinLit:phi1294.phi002",
"maximianus.elegiae" => "urn:cts:latinLit:stoa0196.stoa001",
"nepos.vitae" => "urn:cts:latinLit:phi0588.phi001",
"orosius.apologeticus" => "urn:cts:latinLit:stoa0215c.stoa002",
"orosius.commonitorium_de_errore_priscillianistarum_et_origenistarum" => "urn:cts:latinLit:stoa0215c.stoa003",
"orosius.historiae_adversum_paganos" => "urn:cts:latinLit:stoa0215c.stoa001",
"ovid.amores" => "urn:cts:latinLit:phi0959.phi001",
"ovid.ars_amatoria" => "urn:cts:latinLit:phi0959.phi004",
"ovid.ex_ponto" => "urn:cts:latinLit:phi0959.phi009",
"ovid.fasti" => "urn:cts:latinLit:phi0959.phi007",
"ovid.heroides" => "urn:cts:latinLit:phi0959.phi002",
"ovid.ibis" => "urn:cts:latinLit:phi0959.phi010",
"ovid.medicamina_faciei_femineae" => "urn:cts:latinLit:phi0959.phi003",
"ovid.metamorphoses" => "urn:cts:latinLit:phi0959.phi006",
"ovid.remedia_amoris" => "urn:cts:latinLit:phi0959.phi005",
"ovid.tristia" => "urn:cts:latinLit:phi0959.phi008",
"paulinus_of_nola.carmina" => "urn:cts:latinLit:stoa0223.stoa001",
"paulinus_of_nola.epistulae" => "urn:cts:latinLit:stoa0223.stoa002",
"paulus_diaconus.carmina" => "urn:cts:latinLit:stoa0224.stoa001",
"persius.satires" => "urn:cts:latinLit:phi0969.phi001",
"petronius.satyricon" => "urn:cts:latinLit:phi0972.phi001",
"plautus.amphitruo" => "urn:cts:latinLit:phi0119.phi001",
"plautus.asinaria" => "urn:cts:latinLit:phi0119.phi002",
"plautus.aulularia" => "urn:cts:latinLit:phi0119.phi003",
"plautus.bacchides" => "urn:cts:latinLit:phi0119.phi004",
"plautus.captivi" => "urn:cts:latinLit:phi0119.phi005",
"plautus.casina" => "urn:cts:latinLit:phi0119.phi006",
"plautus.cistellaria" => "urn:cts:latinLit:phi0119.phi007",
"plautus.curculio" => "urn:cts:latinLit:phi0119.phi008",
"plautus.epidicus" => "urn:cts:latinLit:phi0119.phi009",
"plautus.menaechmi" => "urn:cts:latinLit:phi0119.phi010",
"plautus.mercator" => "urn:cts:latinLit:phi0119.phi011",
"plautus.miles_gloriosus" => "urn:cts:latinLit:phi0119.phi012",
"plautus.mostellaria" => "urn:cts:latinLit:phi0119.phi013",
"plautus.persa" => "urn:cts:latinLit:phi0119.phi014",
"plautus.poenulus" => "urn:cts:latinLit:phi0119.phi015",
"plautus.pseudolus" => "urn:cts:latinLit:phi0119.phi016",
"plautus.rudens" => "urn:cts:latinLit:phi0119.phi017",
"plautus.stichus" => "urn:cts:latinLit:phi0119.phi018",
"plautus.trinummus" => "urn:cts:latinLit:phi0119.phi019",
"plautus.truculentus" => "urn:cts:latinLit:phi0119.phi020",
"pliny_the_elder.naturalis_historia" => "urn:cts:latinLit:phi0978.phi001",
"pliny_the_younger.letters" => "urn:cts:latinLit:phi1318.phi001",
"priscian.carmen_in_laudem_Anastasii_imperatoris" => "urn:cts:latinLit:stoa0234a.stoa007",
"priscian.perihegesis" => "urn:cts:latinLit:stoa0234a.stoa009",
"priscillian.canones" => "urn:cts:latinLit:stoa0234e.stoa001",
"priscillian.tractatus_undecim" => "urn:cts:latinLit:stoa0234e.stoa002",
"propertius.elegies" => "urn:cts:latinLit:phi0620.phi001",
"prudentius.apotheosis" => "urn:cts:latinLit:stoa0238.stoa005",
"prudentius.contra_symmachum" => "urn:cts:latinLit:stoa0238.stoa007",
"prudentius.dittochaeon" => "urn:cts:latinLit:stoa0238.stoa008",
"prudentius.epilogus" => "urn:cts:latinLit:stoa0238.stoa009",
"prudentius.hamartigenia" => "urn:cts:latinLit:stoa0238.stoa006",
"prudentius.peristephanon" => "urn:cts:latinLit:stoa0238.stoa001",
"prudentius.psychomachia" => "urn:cts:latinLit:stoa0238.stoa002",
"pseudo_cicero.in_sallustium" => "urn:cts:latinLit:phi0474.phi074",
"pseudo_quintilian.major_declamations" => "urn:cts:latinLit:phi1002.phi003",
"pseudo_vergil.aetna" => "urn:cts:latinLit:phi0692.phi004",
"pseudo_vergil.catalepton" => "urn:cts:latinLit:phi0692.phi009",
"pseudo_vergil.ciris" => "urn:cts:latinLit:phi0692.phi007",
"pseudo_vergil.copa" => "urn:cts:latinLit:phi0692.phi005",
"pseudo_vergil.culex" => "urn:cts:latinLit:phi0692.phi003",
"pseudo_vergil.dirae" => "urn:cts:latinLit:phi0692.phi001",
"pseudo_vergil.elegiae_in_maecenatem" => "urn:cts:latinLit:phi0692.phi006",
"pseudo_vergil.lydia" => "urn:cts:latinLit:phi0692.phi002",
"pseudo_vergil.moretum" => "urn:cts:latinLit:phi0692.phi011",
"pseudo_vergil.priapea" => "urn:cts:latinLit:phi0692.phi008",
"pseudo_vitensis.notitia_provinciarum_et_civitatum_africae" => "urn:cts:latinLit:stoa0292p.stoa002",
"q_cicero.on_running_for_consul" => "urn:cts:latinLit:phi0478.phi003",
"quintilian.institutio_oratoria" => "urn:cts:latinLit:phi1002.phi001",
"rufinus.interpretatio_orationem_gregorii_nazianzeni" => "urn:cts:latinLit:stoa0244d.stoa005",
"rutilius.de_reditu" => "urn:cts:latinLit:stoa0247.stoa001",
"sallust.catilina" => "urn:cts:latinLit:phi0631.phi001",
"sallust.histories" => "urn:cts:latinLit:phi0631.phi003",
"sallust.jugurtha" => "urn:cts:latinLit:phi0631.phi002",
"salvianus.ad_ecclesiam" => "urn:cts:latinLit:stoa0249a.stoa004",
"salvianus.de_gubernatione_dei" => "urn:cts:latinLit:stoa0249a.stoa002",
"scriptores_historiae_augustae.historia_augusta" => "urn:cts:latinLit:phi2331",
"secundinus.epistula_secundini_ad_augustinum" => "urn:cts:latinLit:stoa0251.stoa001",
"sedulius.a_solis_ortus_cardine" => "urn:cts:latinLit:stoa0252.stoa001",
"sedulius.carmen_paschale" => "urn:cts:latinLit:stoa0252.stoa002",
"seneca.ad_lucilium_epistulae_morales" => "urn:cts:latinLit:phi1017.phi015",
"seneca.agamemnon" => "urn:cts:latinLit:phi1017.phi007",
"seneca.apocolocyntosis" => "urn:cts:latinLit:phi1017.phi011",
"seneca.de_beneficiis" => "urn:cts:latinLit:phi1017.phi013",
"seneca.de_brevitate_vitae" => "urn:cts:latinLit:stoa0255.stoa004",
"seneca.de_clementia" => "urn:cts:latinLit:phi1017.phi014",
"seneca.de_consolatione_ad_helviam" => "urn:cts:latinLit:stoa0255.stoa006",
"seneca.de_consolatione_ad_marciam" => "urn:cts:latinLit:stoa0255.stoa007",
"seneca.de_consolatione_ad_polybium" => "urn:cts:latinLit:stoa0255.stoa008",
"seneca.de_constantia" => "urn:cts:latinLit:stoa0255.stoa009",
"seneca.de_ira" => "urn:cts:latinLit:stoa0255.stoa010",
"seneca.de_otio" => "urn:cts:latinLit:stoa0255.stoa011",
"seneca.de_providentia" => "urn:cts:latinLit:stoa0255.stoa012",
"seneca.de_tranquillitate_animi" => "urn:cts:latinLit:stoa0255.stoa013",
"seneca.de_vita_beata" => "urn:cts:latinLit:stoa0255.stoa014",
"seneca.hercules_furens" => "urn:cts:latinLit:phi1017.phi001",
"seneca.hercules_oetaeus" => "urn:cts:latinLit:phi1017.phi009",
"seneca.medea" => "urn:cts:latinLit:phi1017.phi004",
"seneca.octavia" => "urn:cts:latinLit:phi1017.phi010",
"seneca.oedipus" => "urn:cts:latinLit:phi1017.phi006",
"seneca.phaedra" => "urn:cts:latinLit:phi1017.phi005",
"seneca.phoenissae" => "urn:cts:latinLit:phi1017.phi003",
"seneca.quaestiones_naturales" => "urn:cts:latinLit:phi1017.phi016",
"seneca.thyestes" => "urn:cts:latinLit:phi1017.phi008",
"seneca.troades" => "urn:cts:latinLit:phi1017.phi002",
"seneca_the_elder.controversiae" => "urn:cts:latinLit:phi1014.phi001",
"seneca_the_elder.excerpta_controversiae" => "urn:cts:latinLit:phi1014.phi002",
"seneca_the_elder.fragmenta" => "urn:cts:latinLit:phi1014.phi004",
"seneca_the_elder.suasoriae" => "urn:cts:latinLit:phi1014.phi003",
"servius_honoratus.in_virgilii_georgicon_libros_commentarius" => "urn:cts:latinLit:phi2349.phi007",
"silius_italicus.punica" => "urn:cts:latinLit:phi1345.phi001",
"statius.achilleid" => "urn:cts:latinLit:phi1020.phi003",
"statius.silvae" => "urn:cts:latinLit:phi1020.phi002",
"statius.thebaid" => "urn:cts:latinLit:phi1020.phi001",
"suetonius.de_vita_caesarum" => "urn:cts:latinLit:phi1348.phi001",
"sulpicius_severus.chronica" => "urn:cts:latinLit:stoa0270.stoa001",
"sulpicius_severus.dialogi" => "urn:cts:latinLit:stoa0270.stoa003",
"sulpicius_severus.epistula_ad_aurelium" => "urn:cts:latinLit:stoa0270.stoa005",
"sulpicius_severus.epistula_ad_Bassulae_parenti" => "urn:cts:latinLit:stoa0270.stoa005",
"sulpicius_severus.epistula_prima_ad_eusebium" => "urn:cts:latinLit:stoa0270.stoa005",
"sulpicius_severus.vita_martini" => "urn:cts:latinLit:stoa0270.stoa002",
"sulpicius_severus_pseudo.alia_epistula" => "urn:cts:latinLit:stoa0270p.stoa001",
"tacitus.agricola" => "urn:cts:latinLit:phi1351.phi001",
"tacitus.annales" => "urn:cts:latinLit:phi1351.phi005",
"tacitus.de_origine_et_situ_germanorum_liber" => "urn:cts:latinLit:phi1351.phi002",
"tacitus.dialogus_de_oratoribus" => "urn:cts:latinLit:phi1351.phi003",
"tacitus.historiae" => "urn:cts:latinLit:phi1351.phi004",
"terence.adelphi" => "urn:cts:latinLit:phi0134.phi006",
"terence.andria" => "urn:cts:latinLit:phi0134.phi001",
"terence.eunuchus" => "urn:cts:latinLit:phi0134.phi003",
"terence.heautontimorumenos" => "urn:cts:latinLit:phi0134.phi002",
"terence.hecyra" => "urn:cts:latinLit:phi0134.phi005",
"terence.phormio" => "urn:cts:latinLit:phi0134.phi004",
"tertullian.ad_martyres" => "urn:cts:latinLit:stoa0275.stoa001",
"tertullian.ad_nationes" => "urn:cts:latinLit:stoa0275.stoa002",
"tertullian.adversus_hermogenem" => "urn:cts:latinLit:stoa0275.stoa004",
"tertullian.adversus_marcionem" => "urn:cts:latinLit:stoa0275.stoa006",
"tertullian.adversus_praxeam" => "urn:cts:latinLit:stoa0275.stoa007",
"tertullian.adversus_valentinianos" => "urn:cts:latinLit:stoa0275.stoa008",
"tertullian.apologeticum" => "urn:cts:latinLit:stoa0275.stoa009",
"tertullian.de_anima" => "urn:cts:latinLit:stoa0275.stoa010",
"tertullian.de_baptismo" => "urn:cts:latinLit:stoa0275.stoa011",
"tertullian.de_carnis_resurrectione" => "urn:cts:latinLit:stoa0275.stoa026",
"tertullian.de_idololatria" => "urn:cts:latinLit:stoa0275.stoa017",
"tertullian.de_ieiunio" => "urn:cts:latinLit:stoa0275.stoa018",
"tertullian.de_oratione" => "urn:cts:latinLit:stoa0275.stoa020",
"tertullian.de_patientia" => "urn:cts:latinLit:stoa0275.stoa023",
"tertullian.de_pudicitia" => "urn:cts:latinLit:stoa0275.stoa025",
"tertullian.de_scorpiace" => "urn:cts:latinLit:stoa0275.stoa030",
"tertullian.de_spectaculis" => "urn:cts:latinLit:stoa0275.stoa027",
"tertullian.de_testimonio_animae" => "urn:cts:latinLit:stoa0275.stoa028",
"tertullian_pseudo.adversus_omnes_haereses" => "urn:cts:latinLit:stoa0276.stoa003",
"tertullian_pseudo.de_iona_propheta" => "urn:cts:latinLit:stoa0276.stoa006",
"tertullian_pseudo.de_sodoma" => "urn:cts:latinLit:stoa0276.stoa010",
"tibullus.elegies" => "urn:cts:latinLit:phi0660.phi001",
"valerius_flaccus.argonautica" => "urn:cts:latinLit:phi1035.phi001",
"valerius_maximus.facta_et_dicta_memorabilia" => "urn:cts:latinLit:phi1038.phi001",
"vergil.aeneid" => "urn:cts:latinLit:phi0690.phi003",
"vergil.eclogues" => "urn:cts:latinLit:phi0690.phi001",
"vergil.georgics" => "urn:cts:latinLit:phi0690.phi002",
"victorinus.de_machabeis" => "urn:cts:latinLit:stoa0292a.stoa004",
"vitensis.historia_persecutionic_africanae_proviniae" => "urn:cts:latinLit:stoa0292d.stoa001",
"vitruvius.de_architectura" => "urn:cts:latinLit:phi1056.phi001"];

?>
</html>