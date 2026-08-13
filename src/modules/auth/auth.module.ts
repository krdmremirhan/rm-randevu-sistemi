import { JwtModule } from '@nestjs/jwt';
import {  Module } from "@nestjs/common";
import { ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';

@Module({
    imports:[
    JwtModule.registerAsync({
        inject:[ConfigService],
        useFactory:(configService:ConfigService) =>({
            secret : configService.get('JWT_ACCESS_SECRET'),
                    signOptions: { expiresIn: '15m' },

        }),
    }),
    ],
    controllers:[AuthController],
    providers:[AuthService]
})

export class AuthModule {}