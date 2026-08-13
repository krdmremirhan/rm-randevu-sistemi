import { ApiProperty } from '@nestjs/swagger';
import { IsString  } from 'class-validator';

export class LoginDto  {
     @ApiProperty({ example: 'ahmet123' })
  @IsString()
  kullaniciAd: string;

@ApiProperty({ example: 'Sifre123!' })
@IsString()
sifre: string;
}
