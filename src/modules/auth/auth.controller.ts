import { Controller,Post,Body } from "@nestjs/common";
import { AuthService } from "./auth.service";
import { RegisterDto } from "./Dto/register.dto";
import { LoginDto } from "./Dto/login.dto";

@Controller('auth')
export class AuthController {
    constructor(private readonly authService:AuthService) {
        
    }
    @Post('register')
    register(@Body() dto:RegisterDto){
        return this.authService.register(dto)
    }
    @Post('login')
    login(@Body() dto:LoginDto){
        return this.authService.login(dto)
    }
}