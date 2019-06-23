Begin{
    $OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
    clear
    Class Matrix{
        $sprites=@()
        
        Matrix(){

        }
        
        loop(){
            $index = 0
            while($true){
                        
                $index++
                $newSprite = @{
                    x = (get-random -Minimum 1 -maximum ([console]::windowWidth) )
                    y =  (
                        [math]::floor(
                            (
                                get-random -Minimum 1 -maximum (
                                    [console]::windowHeight * .1 
                                )
                            )
                        )
                    )
                    length = (get-random -minimum 45 -maximum ([console]::WindowHeight))
                    iterations = 0
                }                   
                $this.sprites += $newSprite
            
                # while($this.sprites.count -gt 25){
                    # $this.sprites[ 0 ] = $null
                    # $this.sprites = ($this.sprites | ? { $_ -ne $null } | sort { $_.X})
                # }
            
                for($s = 0; $s -lt $this.sprites.count; $s++){
                    if($this.sprites[$s] -ne $null){                        
                        $this.sprites[$s].iterations++
                        $this.sprites[$s].Y++    
                        for($i = 0; $i -le $this.sprites[$s].iterations; $i++){
                            # for($x = $this.sprites[$s].X - 1; $x -lt $this.sprites[$s].X + 1; $x++){
                                if(  ($this.sprites[$s].Y + $i) -lt ([console]::WindowHeight - 10)){
                                    [console]::SetCursorPosition($this.sprites[$s].x-1, ($this.sprites[$s].Y + $i) )
                                    write-host -noNewLine "$([char]27)[38;2;0;0;0m###$([char]27)[" 
                                }
                            # }
                        }
                        
                        for($i = 0; $i -le $this.sprites[$s].iterations; $i++){
                            if(  ($this.sprites[$s].Y + $i) -lt ([console]::WindowHeight - 10)){
                            
                                $gCounter = [math]::floor( 255 / $this.sprites[$s].iterations)
                                if( ($i) -lt $this.sprites[$s].length ){
                                
                                    [console]::SetCursorPosition($this.sprites[$s].X, ($this.sprites[$s].Y + $i) )
                                    write-host -noNewLine "$([char]27)[38;2;24;$($gCounter * $i);25m$([char](19968 + (get-random -minimum 1 -maximum 400)))$([char]27)[" 
                                    
                                    # write-host -noNewLine "$([char]27)[38;2;24;$($gCounter * $i);25m$([char](96 + (get-random -minimum 1 -maximum 26)))$([char]27)[" 
                                    
                                }
                                
                                if( ($this.sprites[$s].Y + $this.sprites[$s].iterations) -ge ([console]::windowHeight + 25)){
                                    $this.sprites[$s] = $null
                                    $this.sprites += @{
                                        x = (get-random -Minimum 1 -maximum ([console]::windowWidth) )
                                        y =  (
                                            [math]::floor(
                                                (
                                                    get-random -Minimum 1 -maximum (
                                                        [console]::windowHeight * .1 
                                                    )
                                                )
                                            )
                                        )
                                        length = (get-random -minimum 10 -maximum ([console]::WindowHeight))
                                        iterations = 0
                                    }
                                }
                            }
                        }
                        if(  ($this.sprites[$s].Y + $i) -lt ([console]::WindowHeight - 10)){
                            [console]::SetCursorPosition($this.sprites[$s].X, ($this.sprites[$s].Y + $i - 1) )
                            write-host -noNewLine "$([char]27)[38;2;255;255;255m$([char](19968 + (get-random -minimum 1 -maximum 400)))$([char]27)[" 
                            # write-host -noNewLine "$([char]27)[38;2;255;255;255m$([char](96 + (get-random -minimum 1 -maximum 26)))$([char]27)[" 
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
