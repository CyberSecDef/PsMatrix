Begin{
    $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
    clear
    Class Sprite{
        $X              = (get-random -Minimum 1 -maximum ([console]::windowWidth) )
        $Y              = ( [math]::floor( ( get-random -Minimum 1 -maximum ( [console]::windowHeight * .1 ))))
        $Length         = (get-random -minimum 45 -maximum ([console]::WindowHeight * 5))
        $Iterations     = 0
        $active         = $true
        Sprite(){
        
        }
        
        drawTail(){
            if($this.active){
                for($i = 0; $i -le $this.iterations; $i++){
                    if(  ($this.Y + $i) -lt ([console]::WindowHeight - 10)){
                        $gCounter = [math]::floor( 172 / $this.iterations)
                            [console]::SetCursorPosition($this.X, ($this.Y + $i) )
                            write-host -noNewLine "$([char]27)[38;2;24;$(96 + $gCounter * $i);25m$([char](19968 + (get-random -minimum 1 -maximum 400)))$([char]27)[" 
                        if( ($this.Y + $this.iterations) -ge ([console]::windowHeight + 25)){
                            $this.active = $false
                        }
                    }
                }
            }
        }
        drawHead(){
            if($this.active){
                if(  ($this.Y + $this.iterations) -lt ([console]::WindowHeight - 10)){
                    [console]::SetCursorPosition($this.X, ($this.Y + $this.iterations ) )
                    write-host -noNewLine "$([char]27)[38;2;255;255;255m$([char](19968 + (get-random -minimum 1 -maximum 400)))$([char]27)[" 
                }
            }
        }
        
    }
    
    Class Matrix{
        $sprites=@()
        
        Matrix(){
            for($x = 0; $x -lt [console]::windowWidth; $x++){
                for($y = 0; $y -lt [console]::windowHeight - 10; $y++){
                    $gCounter = get-random -minimum 48 -maximum 128
                    [console]::SetCursorPosition($X, ($Y) )
                    write-host -noNewLine "$([char]27)[38;2;24;$($gCounter);25m$([char](19968 + (get-random -minimum 1 -maximum 400)))$([char]27)[" 
                }
            }
        }
        
        loop(){
            $index = 0
            while($true){
                        
                $index++
                if( ($this.sprites | ? { $_.active}).count -lt 100){
                    $this.sprites += [Sprite]::new()
                }
                while( ($this.sprites | ? { $_.active}).count -gt 100){
                    $this.sprites[ (get-random -minimum 0 -maximum $this.sprites.count) ] = $null
                    $this.sprites = ($this.sprites | ? { $_ -ne $null } | sort { $_.X})
                }
            
                for($s = 0; $s -lt $this.sprites.count; $s++){
                    if( (get-random -minimum 1 -maximum 1000) -gt 750){
                        if($this.sprites[$s].active){                        
                            $this.sprites[$s].iterations++
                            $this.sprites[$s].Y++    
                            $this.sprites[$s].drawTail();
                            $this.sprites[$s].drawHead();
                        }
                    }
                }
                
            }
        }
    }
}
Process{
    $matrix = [Matrix]::new()
    $matrix.loop()
}
End{

}
