import { IsString, IsEmail, MinLength, IsOptional,  } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterDto {
  @ApiProperty({ example: 'ahmet123' })
  @IsString()
  @MinLength(3)
  kullaniciAd: string;

  // TODO: email alanı — opsiyonel, ama girilirse geçerli bir email olmalı
  // ipucu: @ApiPropertyOptional() + @IsOptional() + @IsEmail() üçü birlikte
    @ApiPropertyOptional({
        example:'ahmet@example.com',
    })
    @IsOptional()
    @IsEmail()
    email?:string;
  // TODO: sifre alanı — zorunlu, en az 8 karakter
@ApiProperty({ example: 'Sifre123!' })
@MinLength(8)
@IsString()
sifre:string;
  // TODO: ad alanı — opsiyonel string
@ApiPropertyOptional({ example: 'Ahmet' })
@IsOptional()
@IsString()
ad?: string;
  // TODO: soyad alanı — opsiyonel string
  @ApiPropertyOptional({ example: 'Polat' })
  @IsOptional()
  @IsString()
  soyad?:string;
}