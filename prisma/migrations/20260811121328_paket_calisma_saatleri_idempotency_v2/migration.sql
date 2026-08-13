-- CreateEnum
CREATE TYPE "Cinsiyet" AS ENUM ('KADIN', 'ERKEK', 'BELIRTILMEDI');

-- CreateEnum
CREATE TYPE "OrganizationDurumu" AS ENUM ('AKTIF', 'PASIF', 'SUSPENDED', 'SILINDI');

-- CreateEnum
CREATE TYPE "SubscriptionDurumu" AS ENUM ('DENEME', 'AKTIF', 'GECIKMIS', 'DONDURULDU', 'IPTAL_EDILDI', 'SONA_ERDI');

-- CreateEnum
CREATE TYPE "FaturalandirmaPeriyodu" AS ENUM ('AYLIK', 'YILLIK');

-- CreateEnum
CREATE TYPE "RandevuDurumu" AS ENUM ('PLANLANDI', 'ONAYLANDI', 'TAMAMLANDI', 'IPTAL_EDILDI', 'ERTELENDI', 'GELMEDI');

-- CreateEnum
CREATE TYPE "RandevuKaynak" AS ENUM ('PANEL', 'TELEFON', 'EMAIL', 'WHATSAPP', 'WEB', 'API', 'DIGER');

-- CreateEnum
CREATE TYPE "RandevuElemanRolu" AS ENUM ('SORUMLU', 'ASISTAN', 'TEKNISYEN', 'GOZLEMCI');

-- CreateEnum
CREATE TYPE "ServisTuru" AS ENUM ('BAKIM', 'ONARIM', 'KURULUM', 'KONTROL', 'DANISMANLIK', 'DIGER');

-- CreateEnum
CREATE TYPE "AciliyetSeviyesi" AS ENUM ('DUSUK', 'NORMAL', 'YUKSEK', 'KRITIK');

-- CreateEnum
CREATE TYPE "AktiviteTipi" AS ENUM ('NOT', 'ARAMA', 'EMAIL', 'SMS', 'WHATSAPP', 'RANDEVU', 'TEKLIF', 'ODEME', 'PAKET', 'GOREV', 'SISTEM');

-- CreateEnum
CREATE TYPE "AktiviteDurumu" AS ENUM ('PLANLANDI', 'DEVAM_EDIYOR', 'TAMAMLANDI', 'IPTAL_EDILDI');

-- CreateEnum
CREATE TYPE "GorevDurumu" AS ENUM ('BEKLIYOR', 'DEVAM_EDIYOR', 'TAMAMLANDI', 'IPTAL_EDILDI');

-- CreateEnum
CREATE TYPE "GorevOnceligi" AS ENUM ('DUSUK', 'NORMAL', 'YUKSEK', 'KRITIK');

-- CreateEnum
CREATE TYPE "PaketDurumu" AS ENUM ('AKTIF', 'PASIF', 'ARSIVLENDI');

-- CreateEnum
CREATE TYPE "MusteriPaketDurumu" AS ENUM ('BEKLIYOR', 'AKTIF', 'SONA_ERDI', 'IPTAL_EDILDI', 'DONDURULDU');

-- CreateEnum
CREATE TYPE "OdemeDurumu" AS ENUM ('BEKLIYOR', 'ODEME_ALINDI', 'KISMI_ODEME', 'GECIKTI', 'IPTAL_EDILDI', 'IADE_EDILDI');

-- CreateEnum
CREATE TYPE "OdemeYontemi" AS ENUM ('NAKIT', 'KREDI_KARTI', 'HAVALE', 'EFT', 'ONLINE', 'DIGER');

-- CreateEnum
CREATE TYPE "ParaBirimi" AS ENUM ('TRY', 'USD', 'EUR', 'GBP');

-- CreateEnum
CREATE TYPE "BildirimKanali" AS ENUM ('EMAIL', 'SMS', 'WHATSAPP', 'PUSH');

-- CreateEnum
CREATE TYPE "BildirimDurumu" AS ENUM ('BEKLIYOR', 'GONDERILIYOR', 'GONDERILDI', 'BASARISIZ', 'IPTAL_EDILDI');

-- CreateEnum
CREATE TYPE "BildirimTipi" AS ENUM ('RANDEVU_OLUSTURULDU', 'RANDEVU_ONAYLANDI', 'RANDEVU_HATIRLATMA', 'RANDEVU_DEGISTIRILDI', 'RANDEVU_IPTAL_EDILDI', 'PAKET_BITIYOR', 'ODEME_HATIRLATMA', 'GOREV_ATANDI', 'GENEL');

-- CreateEnum
CREATE TYPE "AuditAction" AS ENUM ('CREATE', 'UPDATE', 'DELETE', 'RESTORE', 'LOGIN', 'LOGOUT', 'LOGIN_FAILED', 'PASSWORD_CHANGE', 'STATUS_CHANGE');

-- CreateEnum
CREATE TYPE "DosyaTipi" AS ENUM ('BELGE', 'SOZLESME', 'RAPOR', 'FATURA', 'GORSEL', 'DIGER');

-- CreateEnum
CREATE TYPE "DosyaYuklemeDurumu" AS ENUM ('BEKLIYOR', 'TAMAMLANDI', 'BASARISIZ');

-- CreateEnum
CREATE TYPE "CalismaGunuIstisnasiTipi" AS ENUM ('KAPALI', 'OZEL_SAAT');

-- CreateEnum
CREATE TYPE "OdemeSaglayici" AS ENUM ('IYZICO', 'PAYTR', 'STRIPE', 'DIGER');

-- CreateEnum
CREATE TYPE "WebhookIslenmeDurumu" AS ENUM ('ISLENDI', 'YOKSAYILDI', 'HATALI');

-- CreateEnum
CREATE TYPE "IdempotencyDurumu" AS ENUM ('ISLENIYOR', 'TAMAMLANDI', 'BASARISIZ');

-- CreateTable
CREATE TABLE "Organization" (
    "id" SERIAL NOT NULL,
    "ad" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "email" TEXT,
    "telefon" TEXT,
    "website" TEXT,
    "vergiNo" TEXT,
    "vergiDairesi" TEXT,
    "durum" "OrganizationDurumu" NOT NULL DEFAULT 'AKTIF',
    "saatDilimi" TEXT NOT NULL DEFAULT 'Europe/Istanbul',
    "varsayilanBildirimId" INTEGER,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,
    "deletedAt" TIMESTAMPTZ(3),

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubscriptionPlan" (
    "id" SERIAL NOT NULL,
    "ad" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "aciklama" TEXT,
    "fiyat" DECIMAL(12,2) NOT NULL,
    "paraBirimi" "ParaBirimi" NOT NULL DEFAULT 'TRY',
    "periyot" "FaturalandirmaPeriyodu" NOT NULL DEFAULT 'AYLIK',
    "denemeGunSayisi" INTEGER NOT NULL DEFAULT 0,
    "maxKullanici" INTEGER,
    "maxMusteri" INTEGER,
    "maxRandevuAylik" INTEGER,
    "maxDepolamaMb" INTEGER,
    "ozellikler" JSONB,
    "aktif" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "SubscriptionPlan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationSubscription" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "planId" INTEGER NOT NULL,
    "durum" "SubscriptionDurumu" NOT NULL DEFAULT 'DENEME',
    "periyot" "FaturalandirmaPeriyodu" NOT NULL DEFAULT 'AYLIK',
    "baslangicTarihi" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "bitisTarihi" TIMESTAMPTZ(3),
    "denemeBitisTarihi" TIMESTAMPTZ(3),
    "otomatikYenileme" BOOLEAN NOT NULL DEFAULT true,
    "hariciSubscriptionId" TEXT,
    "hariciCustomerId" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "OrganizationSubscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Role" (
    "id" SERIAL NOT NULL,
    "ad" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "aciklama" TEXT,
    "sistemRolu" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Permission" (
    "id" SERIAL NOT NULL,
    "ad" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "aciklama" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Permission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RolePermission" (
    "roleId" INTEGER NOT NULL,
    "permissionId" INTEGER NOT NULL,

    CONSTRAINT "RolePermission_pkey" PRIMARY KEY ("roleId","permissionId")
);

-- CreateTable
CREATE TABLE "Kullanici" (
    "id" SERIAL NOT NULL,
    "kullaniciAd" TEXT NOT NULL,
    "email" TEXT,
    "sifreHash" TEXT NOT NULL,
    "ad" TEXT,
    "soyad" TEXT,
    "telefon" TEXT,
    "aktif" BOOLEAN NOT NULL DEFAULT true,
    "sonGirisAt" TIMESTAMPTZ(3),
    "musteriId" INTEGER,
    "elemanId" INTEGER,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Kullanici_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationMember" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "kullaniciId" INTEGER NOT NULL,
    "roleId" INTEGER NOT NULL,
    "aktif" BOOLEAN NOT NULL DEFAULT true,
    "davetEdildiAt" TIMESTAMPTZ(3),
    "kabulEdildiAt" TIMESTAMPTZ(3),
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "OrganizationMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER,
    "kullaniciId" INTEGER NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMPTZ(3) NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revokedAt" TIMESTAMPTZ(3),
    "ipAddress" TEXT,
    "userAgent" TEXT,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Musteri" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "firmaAd" TEXT,
    "vergiNo" TEXT,
    "vergiDairesi" TEXT,
    "telefon" TEXT,
    "email" TEXT,
    "website" TEXT,
    "aktif" BOOLEAN NOT NULL DEFAULT true,
    "notlar" TEXT,
    "varsayilanBildirimId" INTEGER,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,
    "deletedAt" TIMESTAMPTZ(3),

    CONSTRAINT "Musteri_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MusteriKisi" (
    "id" SERIAL NOT NULL,
    "musteriId" INTEGER NOT NULL,
    "ad" TEXT NOT NULL,
    "soyad" TEXT,
    "telefon" TEXT,
    "email" TEXT,
    "gorev" TEXT,
    "departman" TEXT,
    "cinsiyet" "Cinsiyet",
    "anaYetkili" BOOLEAN NOT NULL DEFAULT false,
    "aktif" BOOLEAN NOT NULL DEFAULT true,
    "notlar" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,
    "deletedAt" TIMESTAMPTZ(3),

    CONSTRAINT "MusteriKisi_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Eleman" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "ad" TEXT NOT NULL,
    "soyad" TEXT,
    "telefon" TEXT,
    "email" TEXT,
    "pozisyon" TEXT,
    "yas" INTEGER,
    "cinsiyet" "Cinsiyet",
    "aktif" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,
    "deletedAt" TIMESTAMPTZ(3),

    CONSTRAINT "Eleman_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalismaSaati" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER,
    "elemanId" INTEGER,
    "gun" INTEGER NOT NULL,
    "baslangicSaat" TEXT NOT NULL,
    "bitisSaat" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "CalismaSaati_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tatil" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "tarih" DATE NOT NULL,
    "ad" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Tatil_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CalismaGunuIstisnasi" (
    "id" SERIAL NOT NULL,
    "elemanId" INTEGER NOT NULL,
    "tarih" DATE NOT NULL,
    "tip" "CalismaGunuIstisnasiTipi" NOT NULL,
    "baslangicSaat" TEXT,
    "bitisSaat" TEXT,
    "aciklama" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CalismaGunuIstisnasi_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Randevu" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "musteriId" INTEGER NOT NULL,
    "musteriKisiId" INTEGER,
    "musteriPaketId" INTEGER,
    "randevuBaslangic" TIMESTAMPTZ(3) NOT NULL,
    "randevuBitis" TIMESTAMPTZ(3),
    "durum" "RandevuDurumu" NOT NULL DEFAULT 'PLANLANDI',
    "kaynak" "RandevuKaynak" NOT NULL DEFAULT 'PANEL',
    "servisTuru" "ServisTuru",
    "aciliyetSeviyesi" "AciliyetSeviyesi" NOT NULL DEFAULT 'NORMAL',
    "randevuAlani" TEXT,
    "sikayet" TEXT,
    "gelismeKonusu" TEXT,
    "notlar" TEXT,
    "iptalNedeni" TEXT,
    "ertelenmeNedeni" TEXT,
    "eskiRandevuId" INTEGER,
    "bildirimOverrideId" INTEGER,
    "createdById" INTEGER,
    "updatedById" INTEGER,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,
    "deletedAt" TIMESTAMPTZ(3),

    CONSTRAINT "Randevu_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RandevuEleman" (
    "id" SERIAL NOT NULL,
    "randevuId" INTEGER NOT NULL,
    "elemanId" INTEGER NOT NULL,
    "rol" "RandevuElemanRolu" NOT NULL DEFAULT 'ASISTAN',

    CONSTRAINT "RandevuEleman_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Paket" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "paketAd" TEXT NOT NULL,
    "aciklama" TEXT,
    "fiyat" DECIMAL(12,2) NOT NULL,
    "paraBirimi" "ParaBirimi" NOT NULL DEFAULT 'TRY',
    "sureGun" INTEGER,
    "seansSayisi" INTEGER,
    "durum" "PaketDurumu" NOT NULL DEFAULT 'AKTIF',
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,
    "deletedAt" TIMESTAMPTZ(3),

    CONSTRAINT "Paket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MusteriPaket" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "musteriId" INTEGER NOT NULL,
    "paketId" INTEGER NOT NULL,
    "baslangicTarihi" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "bitisTarihi" TIMESTAMPTZ(3),
    "durum" "MusteriPaketDurumu" NOT NULL DEFAULT 'BEKLIYOR',
    "satisFiyati" DECIMAL(12,2) NOT NULL,
    "paraBirimi" "ParaBirimi" NOT NULL DEFAULT 'TRY',
    "indirim" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "otomatikYenileme" BOOLEAN NOT NULL DEFAULT false,
    "notlar" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "MusteriPaket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Odeme" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "musteriId" INTEGER NOT NULL,
    "musteriPaketId" INTEGER,
    "tutar" DECIMAL(12,2) NOT NULL,
    "paraBirimi" "ParaBirimi" NOT NULL DEFAULT 'TRY',
    "durum" "OdemeDurumu" NOT NULL DEFAULT 'BEKLIYOR',
    "yontem" "OdemeYontemi",
    "islemNo" TEXT,
    "aciklama" TEXT,
    "odemeTarihi" TIMESTAMPTZ(3),
    "createdById" INTEGER,
    "updatedById" INTEGER,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Odeme_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PaymentWebhookEvent" (
    "id" SERIAL NOT NULL,
    "saglayici" "OdemeSaglayici" NOT NULL,
    "saglayiciEventId" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "islenmeDurumu" "WebhookIslenmeDurumu" NOT NULL DEFAULT 'ISLENDI',
    "hataMesaji" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PaymentWebhookEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IdempotencyKey" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "key" TEXT NOT NULL,
    "requestHash" TEXT NOT NULL,
    "durum" "IdempotencyDurumu" NOT NULL DEFAULT 'ISLENIYOR',
    "statusCode" INTEGER,
    "responseBody" JSONB,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "IdempotencyKey_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Aktivite" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "musteriId" INTEGER NOT NULL,
    "kullaniciId" INTEGER,
    "randevuId" INTEGER,
    "tip" "AktiviteTipi" NOT NULL,
    "durum" "AktiviteDurumu" NOT NULL DEFAULT 'TAMAMLANDI',
    "baslik" TEXT NOT NULL,
    "aciklama" TEXT,
    "planlananAt" TIMESTAMPTZ(3),
    "tamamlananAt" TIMESTAMPTZ(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Aktivite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Gorev" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "musteriId" INTEGER,
    "elemanId" INTEGER,
    "atananKullaniciId" INTEGER,
    "baslik" TEXT NOT NULL,
    "aciklama" TEXT,
    "durum" "GorevDurumu" NOT NULL DEFAULT 'BEKLIYOR',
    "oncelik" "GorevOnceligi" NOT NULL DEFAULT 'NORMAL',
    "baslangicTarihi" TIMESTAMPTZ(3),
    "sonTarih" TIMESTAMPTZ(3),
    "tamamlanmaTarihi" TIMESTAMPTZ(3),
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Gorev_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ServisRapor" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "musteriId" INTEGER NOT NULL,
    "randevuId" INTEGER NOT NULL,
    "baslik" TEXT,
    "sikayet" TEXT,
    "yapilanIslem" TEXT,
    "sonuc" TEXT,
    "aciklama" TEXT,
    "kapaliGunSayisi" INTEGER,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "ServisRapor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BildirimTercihi" (
    "id" SERIAL NOT NULL,
    "emailAktif" BOOLEAN NOT NULL DEFAULT true,
    "smsAktif" BOOLEAN NOT NULL DEFAULT false,
    "whatsappAktif" BOOLEAN NOT NULL DEFAULT false,
    "pushAktif" BOOLEAN NOT NULL DEFAULT false,
    "randevuHatirlatma" BOOLEAN NOT NULL DEFAULT true,
    "paketBitisUyarisi" BOOLEAN NOT NULL DEFAULT true,
    "odemeHatirlatma" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "BildirimTercihi_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bildirim" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "musteriId" INTEGER,
    "kullaniciId" INTEGER,
    "tip" "BildirimTipi" NOT NULL,
    "kanal" "BildirimKanali" NOT NULL,
    "durum" "BildirimDurumu" NOT NULL DEFAULT 'BEKLIYOR',
    "baslik" TEXT NOT NULL,
    "mesaj" TEXT NOT NULL,
    "planlananAt" TIMESTAMPTZ(3),
    "gonderildiAt" TIMESTAMPTZ(3),
    "hataMesaji" TEXT,
    "denemeSayisi" INTEGER NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Bildirim_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Dosya" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "musteriId" INTEGER,
    "musteriKisiId" INTEGER,
    "ad" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "boyutByte" BIGINT NOT NULL,
    "tip" "DosyaTipi" NOT NULL DEFAULT 'DIGER',
    "yuklemeDurumu" "DosyaYuklemeDurumu" NOT NULL DEFAULT 'BEKLIYOR',
    "storageKey" TEXT NOT NULL,
    "url" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMPTZ(3),

    CONSTRAINT "Dosya_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER,
    "kullaniciId" INTEGER,
    "requestId" TEXT,
    "action" "AuditAction" NOT NULL,
    "entity" TEXT NOT NULL,
    "entityId" INTEGER NOT NULL,
    "oldData" JSONB,
    "newData" JSONB,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Organization_slug_key" ON "Organization"("slug");

-- CreateIndex
CREATE INDEX "Organization_durum_idx" ON "Organization"("durum");

-- CreateIndex
CREATE INDEX "Organization_email_idx" ON "Organization"("email");

-- CreateIndex
CREATE INDEX "Organization_createdAt_idx" ON "Organization"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "SubscriptionPlan_slug_key" ON "SubscriptionPlan"("slug");

-- CreateIndex
CREATE INDEX "SubscriptionPlan_aktif_idx" ON "SubscriptionPlan"("aktif");

-- CreateIndex
CREATE INDEX "OrganizationSubscription_organizationId_idx" ON "OrganizationSubscription"("organizationId");

-- CreateIndex
CREATE INDEX "OrganizationSubscription_planId_idx" ON "OrganizationSubscription"("planId");

-- CreateIndex
CREATE INDEX "OrganizationSubscription_durum_idx" ON "OrganizationSubscription"("durum");

-- CreateIndex
CREATE INDEX "OrganizationSubscription_bitisTarihi_idx" ON "OrganizationSubscription"("bitisTarihi");

-- CreateIndex
CREATE UNIQUE INDEX "Role_slug_key" ON "Role"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Permission_slug_key" ON "Permission"("slug");

-- CreateIndex
CREATE INDEX "RolePermission_permissionId_idx" ON "RolePermission"("permissionId");

-- CreateIndex
CREATE UNIQUE INDEX "Kullanici_kullaniciAd_key" ON "Kullanici"("kullaniciAd");

-- CreateIndex
CREATE UNIQUE INDEX "Kullanici_email_key" ON "Kullanici"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Kullanici_elemanId_key" ON "Kullanici"("elemanId");

-- CreateIndex
CREATE INDEX "Kullanici_musteriId_idx" ON "Kullanici"("musteriId");

-- CreateIndex
CREATE INDEX "Kullanici_aktif_idx" ON "Kullanici"("aktif");

-- CreateIndex
CREATE INDEX "OrganizationMember_organizationId_idx" ON "OrganizationMember"("organizationId");

-- CreateIndex
CREATE INDEX "OrganizationMember_kullaniciId_idx" ON "OrganizationMember"("kullaniciId");

-- CreateIndex
CREATE INDEX "OrganizationMember_roleId_idx" ON "OrganizationMember"("roleId");

-- CreateIndex
CREATE INDEX "OrganizationMember_aktif_idx" ON "OrganizationMember"("aktif");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationMember_organizationId_kullaniciId_key" ON "OrganizationMember"("organizationId", "kullaniciId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_tokenHash_key" ON "Session"("tokenHash");

-- CreateIndex
CREATE INDEX "Session_organizationId_idx" ON "Session"("organizationId");

-- CreateIndex
CREATE INDEX "Session_kullaniciId_idx" ON "Session"("kullaniciId");

-- CreateIndex
CREATE INDEX "Session_expiresAt_idx" ON "Session"("expiresAt");

-- CreateIndex
CREATE INDEX "Musteri_organizationId_idx" ON "Musteri"("organizationId");

-- CreateIndex
CREATE INDEX "Musteri_organizationId_firmaAd_idx" ON "Musteri"("organizationId", "firmaAd");

-- CreateIndex
CREATE INDEX "Musteri_organizationId_email_idx" ON "Musteri"("organizationId", "email");

-- CreateIndex
CREATE INDEX "Musteri_organizationId_telefon_idx" ON "Musteri"("organizationId", "telefon");

-- CreateIndex
CREATE INDEX "Musteri_organizationId_aktif_idx" ON "Musteri"("organizationId", "aktif");

-- CreateIndex
CREATE INDEX "Musteri_createdAt_idx" ON "Musteri"("createdAt");

-- CreateIndex
CREATE INDEX "MusteriKisi_musteriId_idx" ON "MusteriKisi"("musteriId");

-- CreateIndex
CREATE INDEX "MusteriKisi_email_idx" ON "MusteriKisi"("email");

-- CreateIndex
CREATE INDEX "MusteriKisi_telefon_idx" ON "MusteriKisi"("telefon");

-- CreateIndex
CREATE INDEX "MusteriKisi_anaYetkili_idx" ON "MusteriKisi"("anaYetkili");

-- CreateIndex
CREATE INDEX "Eleman_organizationId_idx" ON "Eleman"("organizationId");

-- CreateIndex
CREATE INDEX "Eleman_organizationId_aktif_idx" ON "Eleman"("organizationId", "aktif");

-- CreateIndex
CREATE INDEX "Eleman_ad_idx" ON "Eleman"("ad");

-- CreateIndex
CREATE INDEX "Eleman_telefon_idx" ON "Eleman"("telefon");

-- CreateIndex
CREATE INDEX "CalismaSaati_organizationId_gun_idx" ON "CalismaSaati"("organizationId", "gun");

-- CreateIndex
CREATE INDEX "CalismaSaati_elemanId_gun_idx" ON "CalismaSaati"("elemanId", "gun");

-- CreateIndex
CREATE INDEX "Tatil_organizationId_tarih_idx" ON "Tatil"("organizationId", "tarih");

-- CreateIndex
CREATE UNIQUE INDEX "Tatil_organizationId_tarih_key" ON "Tatil"("organizationId", "tarih");

-- CreateIndex
CREATE INDEX "CalismaGunuIstisnasi_elemanId_tarih_idx" ON "CalismaGunuIstisnasi"("elemanId", "tarih");

-- CreateIndex
CREATE UNIQUE INDEX "CalismaGunuIstisnasi_elemanId_tarih_key" ON "CalismaGunuIstisnasi"("elemanId", "tarih");

-- CreateIndex
CREATE INDEX "Randevu_organizationId_idx" ON "Randevu"("organizationId");

-- CreateIndex
CREATE INDEX "Randevu_organizationId_randevuBaslangic_idx" ON "Randevu"("organizationId", "randevuBaslangic");

-- CreateIndex
CREATE INDEX "Randevu_organizationId_randevuBaslangic_randevuBitis_idx" ON "Randevu"("organizationId", "randevuBaslangic", "randevuBitis");

-- CreateIndex
CREATE INDEX "Randevu_organizationId_durum_idx" ON "Randevu"("organizationId", "durum");

-- CreateIndex
CREATE INDEX "Randevu_musteriId_idx" ON "Randevu"("musteriId");

-- CreateIndex
CREATE INDEX "Randevu_musteriKisiId_idx" ON "Randevu"("musteriKisiId");

-- CreateIndex
CREATE INDEX "Randevu_musteriPaketId_idx" ON "Randevu"("musteriPaketId");

-- CreateIndex
CREATE INDEX "Randevu_servisTuru_idx" ON "Randevu"("servisTuru");

-- CreateIndex
CREATE INDEX "RandevuEleman_elemanId_idx" ON "RandevuEleman"("elemanId");

-- CreateIndex
CREATE UNIQUE INDEX "RandevuEleman_randevuId_elemanId_key" ON "RandevuEleman"("randevuId", "elemanId");

-- CreateIndex
CREATE INDEX "Paket_organizationId_idx" ON "Paket"("organizationId");

-- CreateIndex
CREATE INDEX "Paket_organizationId_durum_idx" ON "Paket"("organizationId", "durum");

-- CreateIndex
CREATE INDEX "MusteriPaket_organizationId_idx" ON "MusteriPaket"("organizationId");

-- CreateIndex
CREATE INDEX "MusteriPaket_musteriId_idx" ON "MusteriPaket"("musteriId");

-- CreateIndex
CREATE INDEX "MusteriPaket_paketId_idx" ON "MusteriPaket"("paketId");

-- CreateIndex
CREATE INDEX "MusteriPaket_durum_idx" ON "MusteriPaket"("durum");

-- CreateIndex
CREATE INDEX "MusteriPaket_bitisTarihi_idx" ON "MusteriPaket"("bitisTarihi");

-- CreateIndex
CREATE UNIQUE INDEX "Odeme_islemNo_key" ON "Odeme"("islemNo");

-- CreateIndex
CREATE INDEX "Odeme_organizationId_idx" ON "Odeme"("organizationId");

-- CreateIndex
CREATE INDEX "Odeme_organizationId_durum_idx" ON "Odeme"("organizationId", "durum");

-- CreateIndex
CREATE INDEX "Odeme_musteriId_idx" ON "Odeme"("musteriId");

-- CreateIndex
CREATE INDEX "Odeme_musteriPaketId_idx" ON "Odeme"("musteriPaketId");

-- CreateIndex
CREATE INDEX "Odeme_odemeTarihi_idx" ON "Odeme"("odemeTarihi");

-- CreateIndex
CREATE INDEX "PaymentWebhookEvent_saglayici_createdAt_idx" ON "PaymentWebhookEvent"("saglayici", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "PaymentWebhookEvent_saglayici_saglayiciEventId_key" ON "PaymentWebhookEvent"("saglayici", "saglayiciEventId");

-- CreateIndex
CREATE INDEX "IdempotencyKey_durum_createdAt_idx" ON "IdempotencyKey"("durum", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "IdempotencyKey_organizationId_key_key" ON "IdempotencyKey"("organizationId", "key");

-- CreateIndex
CREATE INDEX "Aktivite_organizationId_idx" ON "Aktivite"("organizationId");

-- CreateIndex
CREATE INDEX "Aktivite_musteriId_createdAt_idx" ON "Aktivite"("musteriId", "createdAt");

-- CreateIndex
CREATE INDEX "Aktivite_kullaniciId_idx" ON "Aktivite"("kullaniciId");

-- CreateIndex
CREATE INDEX "Aktivite_randevuId_idx" ON "Aktivite"("randevuId");

-- CreateIndex
CREATE INDEX "Aktivite_tip_idx" ON "Aktivite"("tip");

-- CreateIndex
CREATE INDEX "Gorev_organizationId_idx" ON "Gorev"("organizationId");

-- CreateIndex
CREATE INDEX "Gorev_organizationId_durum_idx" ON "Gorev"("organizationId", "durum");

-- CreateIndex
CREATE INDEX "Gorev_musteriId_idx" ON "Gorev"("musteriId");

-- CreateIndex
CREATE INDEX "Gorev_elemanId_idx" ON "Gorev"("elemanId");

-- CreateIndex
CREATE INDEX "Gorev_atananKullaniciId_idx" ON "Gorev"("atananKullaniciId");

-- CreateIndex
CREATE INDEX "Gorev_sonTarih_idx" ON "Gorev"("sonTarih");

-- CreateIndex
CREATE UNIQUE INDEX "ServisRapor_randevuId_key" ON "ServisRapor"("randevuId");

-- CreateIndex
CREATE INDEX "ServisRapor_organizationId_idx" ON "ServisRapor"("organizationId");

-- CreateIndex
CREATE INDEX "ServisRapor_musteriId_idx" ON "ServisRapor"("musteriId");

-- CreateIndex
CREATE INDEX "Bildirim_organizationId_idx" ON "Bildirim"("organizationId");

-- CreateIndex
CREATE INDEX "Bildirim_organizationId_durum_idx" ON "Bildirim"("organizationId", "durum");

-- CreateIndex
CREATE INDEX "Bildirim_musteriId_idx" ON "Bildirim"("musteriId");

-- CreateIndex
CREATE INDEX "Bildirim_kullaniciId_idx" ON "Bildirim"("kullaniciId");

-- CreateIndex
CREATE INDEX "Bildirim_durum_planlananAt_idx" ON "Bildirim"("durum", "planlananAt");

-- CreateIndex
CREATE INDEX "Dosya_organizationId_idx" ON "Dosya"("organizationId");

-- CreateIndex
CREATE INDEX "Dosya_musteriId_idx" ON "Dosya"("musteriId");

-- CreateIndex
CREATE INDEX "Dosya_musteriKisiId_idx" ON "Dosya"("musteriKisiId");

-- CreateIndex
CREATE INDEX "Dosya_yuklemeDurumu_createdAt_idx" ON "Dosya"("yuklemeDurumu", "createdAt");

-- CreateIndex
CREATE INDEX "AuditLog_organizationId_createdAt_idx" ON "AuditLog"("organizationId", "createdAt");

-- CreateIndex
CREATE INDEX "AuditLog_kullaniciId_idx" ON "AuditLog"("kullaniciId");

-- CreateIndex
CREATE INDEX "AuditLog_entity_entityId_idx" ON "AuditLog"("entity", "entityId");

-- CreateIndex
CREATE INDEX "AuditLog_action_idx" ON "AuditLog"("action");

-- CreateIndex
CREATE INDEX "AuditLog_requestId_idx" ON "AuditLog"("requestId");

-- AddForeignKey
ALTER TABLE "Organization" ADD CONSTRAINT "Organization_varsayilanBildirimId_fkey" FOREIGN KEY ("varsayilanBildirimId") REFERENCES "BildirimTercihi"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationSubscription" ADD CONSTRAINT "OrganizationSubscription_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationSubscription" ADD CONSTRAINT "OrganizationSubscription_planId_fkey" FOREIGN KEY ("planId") REFERENCES "SubscriptionPlan"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolePermission" ADD CONSTRAINT "RolePermission_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RolePermission" ADD CONSTRAINT "RolePermission_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "Permission"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Kullanici" ADD CONSTRAINT "Kullanici_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Kullanici" ADD CONSTRAINT "Kullanici_elemanId_fkey" FOREIGN KEY ("elemanId") REFERENCES "Eleman"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationMember" ADD CONSTRAINT "OrganizationMember_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationMember" ADD CONSTRAINT "OrganizationMember_kullaniciId_fkey" FOREIGN KEY ("kullaniciId") REFERENCES "Kullanici"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationMember" ADD CONSTRAINT "OrganizationMember_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_kullaniciId_fkey" FOREIGN KEY ("kullaniciId") REFERENCES "Kullanici"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Musteri" ADD CONSTRAINT "Musteri_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Musteri" ADD CONSTRAINT "Musteri_varsayilanBildirimId_fkey" FOREIGN KEY ("varsayilanBildirimId") REFERENCES "BildirimTercihi"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MusteriKisi" ADD CONSTRAINT "MusteriKisi_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Eleman" ADD CONSTRAINT "Eleman_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalismaSaati" ADD CONSTRAINT "CalismaSaati_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalismaSaati" ADD CONSTRAINT "CalismaSaati_elemanId_fkey" FOREIGN KEY ("elemanId") REFERENCES "Eleman"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tatil" ADD CONSTRAINT "Tatil_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CalismaGunuIstisnasi" ADD CONSTRAINT "CalismaGunuIstisnasi_elemanId_fkey" FOREIGN KEY ("elemanId") REFERENCES "Eleman"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Randevu" ADD CONSTRAINT "Randevu_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Randevu" ADD CONSTRAINT "Randevu_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Randevu" ADD CONSTRAINT "Randevu_musteriKisiId_fkey" FOREIGN KEY ("musteriKisiId") REFERENCES "MusteriKisi"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Randevu" ADD CONSTRAINT "Randevu_musteriPaketId_fkey" FOREIGN KEY ("musteriPaketId") REFERENCES "MusteriPaket"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Randevu" ADD CONSTRAINT "Randevu_eskiRandevuId_fkey" FOREIGN KEY ("eskiRandevuId") REFERENCES "Randevu"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Randevu" ADD CONSTRAINT "Randevu_bildirimOverrideId_fkey" FOREIGN KEY ("bildirimOverrideId") REFERENCES "BildirimTercihi"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Randevu" ADD CONSTRAINT "Randevu_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "Kullanici"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Randevu" ADD CONSTRAINT "Randevu_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "Kullanici"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RandevuEleman" ADD CONSTRAINT "RandevuEleman_randevuId_fkey" FOREIGN KEY ("randevuId") REFERENCES "Randevu"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RandevuEleman" ADD CONSTRAINT "RandevuEleman_elemanId_fkey" FOREIGN KEY ("elemanId") REFERENCES "Eleman"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Paket" ADD CONSTRAINT "Paket_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MusteriPaket" ADD CONSTRAINT "MusteriPaket_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MusteriPaket" ADD CONSTRAINT "MusteriPaket_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MusteriPaket" ADD CONSTRAINT "MusteriPaket_paketId_fkey" FOREIGN KEY ("paketId") REFERENCES "Paket"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Odeme" ADD CONSTRAINT "Odeme_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Odeme" ADD CONSTRAINT "Odeme_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Odeme" ADD CONSTRAINT "Odeme_musteriPaketId_fkey" FOREIGN KEY ("musteriPaketId") REFERENCES "MusteriPaket"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Odeme" ADD CONSTRAINT "Odeme_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "Kullanici"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Odeme" ADD CONSTRAINT "Odeme_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "Kullanici"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IdempotencyKey" ADD CONSTRAINT "IdempotencyKey_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aktivite" ADD CONSTRAINT "Aktivite_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aktivite" ADD CONSTRAINT "Aktivite_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aktivite" ADD CONSTRAINT "Aktivite_kullaniciId_fkey" FOREIGN KEY ("kullaniciId") REFERENCES "Kullanici"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Aktivite" ADD CONSTRAINT "Aktivite_randevuId_fkey" FOREIGN KEY ("randevuId") REFERENCES "Randevu"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gorev" ADD CONSTRAINT "Gorev_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gorev" ADD CONSTRAINT "Gorev_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gorev" ADD CONSTRAINT "Gorev_elemanId_fkey" FOREIGN KEY ("elemanId") REFERENCES "Eleman"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Gorev" ADD CONSTRAINT "Gorev_atananKullaniciId_fkey" FOREIGN KEY ("atananKullaniciId") REFERENCES "Kullanici"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ServisRapor" ADD CONSTRAINT "ServisRapor_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ServisRapor" ADD CONSTRAINT "ServisRapor_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ServisRapor" ADD CONSTRAINT "ServisRapor_randevuId_fkey" FOREIGN KEY ("randevuId") REFERENCES "Randevu"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bildirim" ADD CONSTRAINT "Bildirim_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bildirim" ADD CONSTRAINT "Bildirim_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bildirim" ADD CONSTRAINT "Bildirim_kullaniciId_fkey" FOREIGN KEY ("kullaniciId") REFERENCES "Kullanici"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dosya" ADD CONSTRAINT "Dosya_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dosya" ADD CONSTRAINT "Dosya_musteriId_fkey" FOREIGN KEY ("musteriId") REFERENCES "Musteri"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Dosya" ADD CONSTRAINT "Dosya_musteriKisiId_fkey" FOREIGN KEY ("musteriKisiId") REFERENCES "MusteriKisi"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog_kullaniciId_fkey" FOREIGN KEY ("kullaniciId") REFERENCES "Kullanici"("id") ON DELETE SET NULL ON UPDATE CASCADE;
