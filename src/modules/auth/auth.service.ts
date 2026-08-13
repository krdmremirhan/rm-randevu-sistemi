import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from "@nestjs/common";
import * as argon2 from "argon2";
import { PrismaService } from "../../infra/prisma/prisma.service";
import { RegisterDto } from "./Dto/register.dto";
import { Prisma } from "@prisma/client";
import { JwtService } from "@nestjs/jwt";
import { LoginDto } from "./Dto/login.dto";
import * as crypto from "crypto";
@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}
  async register(dto: RegisterDto) {
    const sifreHash = await argon2.hash(dto.sifre);
    try {
      const kullanici = await this.prisma.kullanici.create({
        data: {
          kullaniciAd: dto.kullaniciAd,
          email: dto.email,
          sifreHash,
          ad: dto.ad,
          soyad: dto.soyad,
        },
      });
      const { sifreHash: _sifreHash, ...kullaniciSonuc } = kullanici;
      return kullaniciSonuc;
    } catch (error) {
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === "P2002"
      ) {
        throw new ConflictException("bu kullanıcı var");
      }
      throw error;
    }
  }
  async login(dto: LoginDto) {
    const kullanici = await this.prisma.kullanici.findUnique({
      where: { kullaniciAd: dto.kullaniciAd },
    });
    if (kullanici == null) {
      throw new UnauthorizedException("kullanıcı veya şifre bulunamadı");
    }
    const sifreDogruMu = await argon2.verify(kullanici.sifreHash, dto.sifre);
    if (!sifreDogruMu) {
      throw new UnauthorizedException("kullanıcı veya şifre bulunamadı");
    }
    const accessToken = this.jwtService.sign({ sub: kullanici.id });
    const refreshToken = crypto.randomBytes(64).toString("hex");
    const tokenHash = crypto
      .createHash("sha256")
      .update(refreshToken)
      .digest("hex");
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
    await this.prisma.session.create({
      data: {
        kullaniciId : kullanici.id,
        tokenHash :tokenHash,
        expiresAt :expiresAt,
      },
    });
    return { accessToken ,refreshToken}
  }
}
