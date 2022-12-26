--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.1

-- Started on 2022-12-26 12:13:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 233 (class 1255 OID 33007)
-- Name: MarkaEkle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."MarkaEkle"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW."MarkaAdi" = UPPER(NEW."MarkaAdi"); -- büyük harfe dönüştürdükten sonra ekle  
  
    RETURN NEW;
END;
$$;


ALTER FUNCTION public."MarkaEkle"() OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 33005)
-- Name: kdv(real); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kdv(sayiinch real, OUT sayicm real) RETURNS real
    LANGUAGE plpgsql
    AS $$
BEGIN
    sayiCM := 0.08 * sayiINCH+sayiINCH;
END;
$$;


ALTER FUNCTION public.kdv(sayiinch real, OUT sayicm real) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 32983)
-- Name: model_ekle(integer, text, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.model_ekle(IN p1 integer, IN p2 text, IN p3 integer)
    LANGUAGE sql
    AS $$
insert into "Model" ("ModelNo","ModelAdi","MarkaNo") values (p1,p2,p3);
$$;


ALTER PROCEDURE public.model_ekle(IN p1 integer, IN p2 text, IN p3 integer) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 33004)
-- Name: musteriara(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.musteriara(aramano integer) RETURNS TABLE(numara integer, adi character varying, soyadi character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT "MusteriNo", "Adi","Soyadi" from Musteri
                 WHERE "MusteriNo" =AramaNo;
END;
$$;


ALTER FUNCTION public.musteriara(aramano integer) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 32995)
-- Name: musteriodemelerinihesapla1(smallint); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.musteriodemelerinihesapla1(IN storeid smallint)
    LANGUAGE plpgsql
    AS $$
DECLARE
   
    odemetoplami double precision;
BEGIN
			Loop
            odemetoplami:=(SELECT SUM(amount) FROM Kiralma WHERE KiralamaUcreti);
            INSERT INTO Kazanclar(KazancNo,KiralamaNo,ToplamKazanc)
            VALUES (Kazanc.KazancNo,Kazanc.KiralamaNo,odemetoplami );
        END LOOP;
END;
$$;


ALTER PROCEDURE public.musteriodemelerinihesapla1(IN storeid smallint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 24618)
-- Name: Adres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Adres" (
    "AdresNo" integer NOT NULL,
    "Adres" character varying(200) NOT NULL,
    "PostaKodu" integer,
    "İlceNo" integer
);


ALTER TABLE public."Adres" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24640)
-- Name: Arac; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Arac" (
    "AracNo" integer NOT NULL,
    "Plaka" text NOT NULL,
    "Yıl" date NOT NULL,
    "RenkNo" integer NOT NULL,
    "ModelNo" integer NOT NULL,
    "AracDurumNo" integer NOT NULL
);


ALTER TABLE public."Arac" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24597)
-- Name: AracDurum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."AracDurum" (
    "AracDurumNo" integer NOT NULL,
    "AracDurum" character varying(30) NOT NULL
);


ALTER TABLE public."AracDurum" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24707)
-- Name: Fatura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Fatura" (
    "FaturaNo" integer NOT NULL,
    "FaturaTarihi" date NOT NULL,
    "KiralamaNo" integer NOT NULL
);


ALTER TABLE public."Fatura" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24777)
-- Name: Gider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Gider" (
    "GiderNo" integer NOT NULL,
    "Sorun" character varying(75) NOT NULL,
    "GiderUcreti" money NOT NULL,
    "AracNo" integer NOT NULL
);


ALTER TABLE public."Gider" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24717)
-- Name: Kazanc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Kazanc" (
    "KazancNo" integer NOT NULL,
    "KiralamaNo" integer NOT NULL,
    "ToplamKazanc" money NOT NULL
);


ALTER TABLE public."Kazanc" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24674)
-- Name: Kiralama; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Kiralama" (
    "KiralamaNo" integer NOT NULL,
    "KiralamaTarihi" date,
    "KiralamaUcreti" money NOT NULL,
    "MusteriNo" integer NOT NULL,
    "AracNo" integer NOT NULL,
    "KiralamaDurumNo" integer NOT NULL
);


ALTER TABLE public."Kiralama" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24602)
-- Name: KiralamaDurum	; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."KiralamaDurum	" (
    "KiralamaDurumNo" integer NOT NULL,
    "KiralamaDurum" character varying(30) NOT NULL,
    "KiralamaSuresi" integer NOT NULL
);


ALTER TABLE public."KiralamaDurum	" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 24592)
-- Name: Marka; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Marka" (
    "MarkaNo" integer NOT NULL,
    "MarkaAdi " character varying(30) NOT NULL
);


ALTER TABLE public."Marka" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24629)
-- Name: Model; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Model" (
    "ModelNo" integer NOT NULL,
    "ModelAdi" character varying(200) NOT NULL,
    "MarkaNo" integer
);


ALTER TABLE public."Model" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24663)
-- Name: Musteri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Musteri" (
    "MusteriNo" integer NOT NULL,
    "Adi" character varying(15) NOT NULL,
    "Soyadi" character varying(15) NOT NULL,
    "TCNo" bigint NOT NULL,
    "Telefon" bigint NOT NULL,
    "AdresNo" integer NOT NULL
);


ALTER TABLE public."Musteri" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 24587)
-- Name: Renk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Renk" (
    "RenkNo" integer NOT NULL,
    "RenkAdi" character varying(20) NOT NULL
);


ALTER TABLE public."Renk" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24696)
-- Name: YolYardım; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."YolYardım" (
    "YolYardımNo" integer NOT NULL,
    "YolYardımDurumu" boolean NOT NULL,
    "KiralamaNo" integer NOT NULL
);


ALTER TABLE public."YolYardım" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 24582)
-- Name: İl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."İl" (
    "İlNo" integer NOT NULL,
    "İlAdi" character varying(20) NOT NULL
);


ALTER TABLE public."İl" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24607)
-- Name: İlce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."İlce" (
    "İlceNo" integer NOT NULL,
    "İlceAdi" character varying(20) NOT NULL,
    "İlNo" integer
);


ALTER TABLE public."İlce" OWNER TO postgres;

--
-- TOC entry 3436 (class 0 OID 24618)
-- Dependencies: 220
-- Data for Name: Adres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Adres" ("AdresNo", "Adres", "PostaKodu", "İlceNo") FROM stdin;
1	Marasal Cakmak Mahallesi 15/12	34160	1
2	Gaziosmanpaşa Caddesi 12	1234	3
3	Stadyum Sokak 14/1	4572	2
\.


--
-- TOC entry 3438 (class 0 OID 24640)
-- Dependencies: 222
-- Data for Name: Arac; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Arac" ("AracNo", "Plaka", "Yıl", "RenkNo", "ModelNo", "AracDurumNo") FROM stdin;
1	34SK4988	2017-01-01	1	3	2
2	59AIL61	2000-04-05	4	10	4
3	06AUD34	2015-05-14	3	4	3
4	59OE59	2019-12-29	2	7	2
6	22MA102	2022-01-10	1	8	4
\.


--
-- TOC entry 3433 (class 0 OID 24597)
-- Dependencies: 217
-- Data for Name: AracDurum; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."AracDurum" ("AracDurumNo", "AracDurum") FROM stdin;
1	Hasarlı
2	Sorunsuz
3	Sigorta Gerekli
4	Hafif Sorunlu
\.


--
-- TOC entry 3442 (class 0 OID 24707)
-- Dependencies: 226
-- Data for Name: Fatura; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Fatura" ("FaturaNo", "FaturaTarihi", "KiralamaNo") FROM stdin;
1	2022-12-15	103
2	2022-11-17	101
3	2022-05-05	102
\.


--
-- TOC entry 3444 (class 0 OID 24777)
-- Dependencies: 228
-- Data for Name: Gider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Gider" ("GiderNo", "Sorun", "GiderUcreti", "AracNo") FROM stdin;
10	Trafik ışıklarında bir carpışma sonucu düşük seviyeli bir kaza olmuştur\n	?1.900,00	2
11	Sigorta Gerekli 	?1.500,00	3
\.


--
-- TOC entry 3443 (class 0 OID 24717)
-- Dependencies: 227
-- Data for Name: Kazanc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Kazanc" ("KazancNo", "KiralamaNo", "ToplamKazanc") FROM stdin;
1	101	?8.000,00
2	102	?1.000,00
3	103	?400,00
\.


--
-- TOC entry 3440 (class 0 OID 24674)
-- Dependencies: 224
-- Data for Name: Kiralama; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Kiralama" ("KiralamaNo", "KiralamaTarihi", "KiralamaUcreti", "MusteriNo", "AracNo", "KiralamaDurumNo") FROM stdin;
101	2022-11-17	?7.000,00	1	2	1
102	2022-05-05	?1.000,00	3	1	2
103	2022-07-15	?400,00	2	4	4
\.


--
-- TOC entry 3434 (class 0 OID 24602)
-- Dependencies: 218
-- Data for Name: KiralamaDurum	; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."KiralamaDurum	" ("KiralamaDurumNo", "KiralamaDurum", "KiralamaSuresi") FROM stdin;
1	Kirada	5
2	Kirada	30
3	Boşta	0
4	Kirada	1
\.


--
-- TOC entry 3432 (class 0 OID 24592)
-- Dependencies: 216
-- Data for Name: Marka; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Marka" ("MarkaNo", "MarkaAdi ") FROM stdin;
1	Mercedes\n
2	Audi
3	Renault
4	BMW
5	Hyundai
\.


--
-- TOC entry 3437 (class 0 OID 24629)
-- Dependencies: 221
-- Data for Name: Model; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Model" ("ModelNo", "ModelAdi", "MarkaNo") FROM stdin;
10	Vito	1
9	C180	1
8	AMD250	1
7	TT	2
5	Symbol	3
4	M4	4
3	Accent	5
15	transorter	3
\.


--
-- TOC entry 3439 (class 0 OID 24663)
-- Dependencies: 223
-- Data for Name: Musteri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Musteri" ("MusteriNo", "Adi", "Soyadi", "TCNo", "Telefon", "AdresNo") FROM stdin;
1	Ahmet	Han	34597430178	53478912445	1
3	Ceyhun 	Aksoy	7643289712	5380733241	3
2	Oguz	Dermen	12345678911	12378942125	2
\.


--
-- TOC entry 3431 (class 0 OID 24587)
-- Dependencies: 215
-- Data for Name: Renk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Renk" ("RenkNo", "RenkAdi") FROM stdin;
1	Beyaz
2	Gri
3	Kırmızı
4	Siyah
\.


--
-- TOC entry 3441 (class 0 OID 24696)
-- Dependencies: 225
-- Data for Name: YolYardım; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."YolYardım" ("YolYardımNo", "YolYardımDurumu", "KiralamaNo") FROM stdin;
11	f	103
12	t	101
13	f	102
\.


--
-- TOC entry 3430 (class 0 OID 24582)
-- Dependencies: 214
-- Data for Name: İl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."İl" ("İlNo", "İlAdi") FROM stdin;
34	İstanbul
11	Bilecik
59	Tekirdağ
54	Sakarya\n
22	Edirne\n
\.


--
-- TOC entry 3435 (class 0 OID 24607)
-- Dependencies: 219
-- Data for Name: İlce; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."İlce" ("İlceNo", "İlceAdi", "İlNo") FROM stdin;
1	Güngören	34
2	YukarıKalamış	59
3	Arifiye\n	54
\.


--
-- TOC entry 3247 (class 2606 OID 24622)
-- Name: Adres Adres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Adres"
    ADD CONSTRAINT "Adres_pkey" PRIMARY KEY ("AdresNo");


--
-- TOC entry 3240 (class 2606 OID 24601)
-- Name: AracDurum AracDurum_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."AracDurum"
    ADD CONSTRAINT "AracDurum_pkey" PRIMARY KEY ("AracDurumNo");


--
-- TOC entry 3253 (class 2606 OID 24644)
-- Name: Arac Arac_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Arac"
    ADD CONSTRAINT "Arac_pkey" PRIMARY KEY ("AracNo");


--
-- TOC entry 3268 (class 2606 OID 24711)
-- Name: Fatura Fatura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Fatura"
    ADD CONSTRAINT "Fatura_pkey" PRIMARY KEY ("FaturaNo");


--
-- TOC entry 3272 (class 2606 OID 24781)
-- Name: Gider Gider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gider"
    ADD CONSTRAINT "Gider_pkey" PRIMARY KEY ("GiderNo");


--
-- TOC entry 3270 (class 2606 OID 24721)
-- Name: Kazanc Kazanc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kazanc"
    ADD CONSTRAINT "Kazanc_pkey" PRIMARY KEY ("KazancNo");


--
-- TOC entry 3242 (class 2606 OID 24606)
-- Name: KiralamaDurum	 KiralamaDurum	_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."KiralamaDurum	"
    ADD CONSTRAINT "KiralamaDurum	_pkey" PRIMARY KEY ("KiralamaDurumNo");


--
-- TOC entry 3261 (class 2606 OID 24678)
-- Name: Kiralama Kiralama_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kiralama"
    ADD CONSTRAINT "Kiralama_pkey" PRIMARY KEY ("KiralamaNo");


--
-- TOC entry 3238 (class 2606 OID 24596)
-- Name: Marka Marka_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Marka"
    ADD CONSTRAINT "Marka_pkey" PRIMARY KEY ("MarkaNo");


--
-- TOC entry 3250 (class 2606 OID 24633)
-- Name: Model Model_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Model"
    ADD CONSTRAINT "Model_pkey" PRIMARY KEY ("ModelNo");


--
-- TOC entry 3258 (class 2606 OID 24667)
-- Name: Musteri Musteri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Musteri"
    ADD CONSTRAINT "Musteri_pkey" PRIMARY KEY ("MusteriNo");


--
-- TOC entry 3236 (class 2606 OID 24591)
-- Name: Renk Renk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Renk"
    ADD CONSTRAINT "Renk_pkey" PRIMARY KEY ("RenkNo");


--
-- TOC entry 3265 (class 2606 OID 24700)
-- Name: YolYardım YolYardım_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."YolYardım"
    ADD CONSTRAINT "YolYardım_pkey" PRIMARY KEY ("YolYardımNo");


--
-- TOC entry 3234 (class 2606 OID 24586)
-- Name: İl İl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."İl"
    ADD CONSTRAINT "İl_pkey" PRIMARY KEY ("İlNo");


--
-- TOC entry 3245 (class 2606 OID 24611)
-- Name: İlce İlce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."İlce"
    ADD CONSTRAINT "İlce_pkey" PRIMARY KEY ("İlceNo");


--
-- TOC entry 3259 (class 1259 OID 24673)
-- Name: fki_Fk_Adres; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_Adres" ON public."Musteri" USING btree ("AdresNo");


--
-- TOC entry 3262 (class 1259 OID 24690)
-- Name: fki_Fk_Arac; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_Arac" ON public."Kiralama" USING btree ("AracNo");


--
-- TOC entry 3254 (class 1259 OID 24662)
-- Name: fki_Fk_Durum; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_Durum" ON public."Arac" USING btree ("AracDurumNo");


--
-- TOC entry 3266 (class 1259 OID 24706)
-- Name: fki_Fk_Kiralama; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_Kiralama" ON public."YolYardım" USING btree ("KiralamaNo");


--
-- TOC entry 3251 (class 1259 OID 24639)
-- Name: fki_Fk_MarkaNo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_MarkaNo" ON public."Model" USING btree ("MarkaNo");


--
-- TOC entry 3255 (class 1259 OID 24656)
-- Name: fki_Fk_Model; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_Model" ON public."Arac" USING btree ("ModelNo");


--
-- TOC entry 3263 (class 1259 OID 24684)
-- Name: fki_Fk_MusteriNo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_MusteriNo" ON public."Kiralama" USING btree ("MusteriNo");


--
-- TOC entry 3256 (class 1259 OID 24650)
-- Name: fki_Fk_Renk; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_Renk" ON public."Arac" USING btree ("RenkNo");


--
-- TOC entry 3248 (class 1259 OID 24628)
-- Name: fki_Fk_İlceNo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_Fk_İlceNo" ON public."Adres" USING btree ("İlceNo");


--
-- TOC entry 3243 (class 1259 OID 24617)
-- Name: fki_fk_IlNo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "fki_fk_IlNo" ON public."İlce" USING btree ("İlNo");


--
-- TOC entry 3287 (class 2620 OID 33008)
-- Name: Marka kayitKontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "kayitKontrol" BEFORE INSERT OR UPDATE ON public."Marka" FOR EACH ROW EXECUTE FUNCTION public."MarkaEkle"();


--
-- TOC entry 3279 (class 2606 OID 24668)
-- Name: Musteri Fk_Adres; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Musteri"
    ADD CONSTRAINT "Fk_Adres" FOREIGN KEY ("AdresNo") REFERENCES public."Adres"("AdresNo") NOT VALID;


--
-- TOC entry 3280 (class 2606 OID 24685)
-- Name: Kiralama Fk_Arac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kiralama"
    ADD CONSTRAINT "Fk_Arac" FOREIGN KEY ("AracNo") REFERENCES public."Arac"("AracNo") NOT VALID;


--
-- TOC entry 3286 (class 2606 OID 24782)
-- Name: Gider Fk_Arac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Gider"
    ADD CONSTRAINT "Fk_Arac" FOREIGN KEY ("AracNo") REFERENCES public."Arac"("AracNo") NOT VALID;


--
-- TOC entry 3276 (class 2606 OID 24657)
-- Name: Arac Fk_Durum; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Arac"
    ADD CONSTRAINT "Fk_Durum" FOREIGN KEY ("AracDurumNo") REFERENCES public."AracDurum"("AracDurumNo") NOT VALID;


--
-- TOC entry 3281 (class 2606 OID 24691)
-- Name: Kiralama Fk_Durum; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kiralama"
    ADD CONSTRAINT "Fk_Durum" FOREIGN KEY ("KiralamaDurumNo") REFERENCES public."KiralamaDurum	"("KiralamaDurumNo") NOT VALID;


--
-- TOC entry 3283 (class 2606 OID 24701)
-- Name: YolYardım Fk_Kiralama; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."YolYardım"
    ADD CONSTRAINT "Fk_Kiralama" FOREIGN KEY ("KiralamaNo") REFERENCES public."Kiralama"("KiralamaNo") NOT VALID;


--
-- TOC entry 3284 (class 2606 OID 24712)
-- Name: Fatura Fk_Kiralama; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Fatura"
    ADD CONSTRAINT "Fk_Kiralama" FOREIGN KEY ("KiralamaNo") REFERENCES public."Kiralama"("KiralamaNo") NOT VALID;


--
-- TOC entry 3285 (class 2606 OID 24722)
-- Name: Kazanc Fk_Kiralama; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kazanc"
    ADD CONSTRAINT "Fk_Kiralama" FOREIGN KEY ("KiralamaNo") REFERENCES public."Kiralama"("KiralamaNo") NOT VALID;


--
-- TOC entry 3275 (class 2606 OID 24634)
-- Name: Model Fk_MarkaNo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Model"
    ADD CONSTRAINT "Fk_MarkaNo" FOREIGN KEY ("MarkaNo") REFERENCES public."Marka"("MarkaNo") NOT VALID;


--
-- TOC entry 3277 (class 2606 OID 24651)
-- Name: Arac Fk_Model; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Arac"
    ADD CONSTRAINT "Fk_Model" FOREIGN KEY ("ModelNo") REFERENCES public."Model"("ModelNo") NOT VALID;


--
-- TOC entry 3282 (class 2606 OID 24679)
-- Name: Kiralama Fk_MusteriNo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Kiralama"
    ADD CONSTRAINT "Fk_MusteriNo" FOREIGN KEY ("MusteriNo") REFERENCES public."Musteri"("MusteriNo") NOT VALID;


--
-- TOC entry 3278 (class 2606 OID 24645)
-- Name: Arac Fk_Renk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Arac"
    ADD CONSTRAINT "Fk_Renk" FOREIGN KEY ("RenkNo") REFERENCES public."Renk"("RenkNo") NOT VALID;


--
-- TOC entry 3274 (class 2606 OID 24623)
-- Name: Adres Fk_İlceNo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Adres"
    ADD CONSTRAINT "Fk_İlceNo" FOREIGN KEY ("İlceNo") REFERENCES public."İlce"("İlceNo") NOT VALID;


--
-- TOC entry 3273 (class 2606 OID 24612)
-- Name: İlce fk_IlNo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."İlce"
    ADD CONSTRAINT "fk_IlNo" FOREIGN KEY ("İlNo") REFERENCES public."İl"("İlNo") NOT VALID;


-- Completed on 2022-12-26 12:13:34

--
-- PostgreSQL database dump complete
--

