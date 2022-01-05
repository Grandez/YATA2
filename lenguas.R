load = function() {
df = read.csv2("lenguas2.csv")
head(df)
df$Idioma = tolower(df$Idioma)
df$Subidioma = tolower(df$Subidioma)
df$Idioma = as.factor(df$Idioma)
df$Subidioma = as.factor(df$Subidioma)
df$Continente = as.factor(df$Continente)
df$Poblacion = round(df$Poblacion / 1000)
df   
}
df = load()
df2 = df %>% group_by(Idioma) %>% summarise(paises=n(), pob=sum(Poblacion))

df2[order(df2$paises, decreasing=T),]

# Quitamos paises pequeños
size=1000
df3 = df[df$Poblacion > size,]
df4 = df3 %>% group_by(Idioma) %>% summarise(paises=n(), pob=sum(Poblacion))
df4[order(df4$paises, decreasing=T),]

# Caso nigeria:
# Idioma oficial Ingles, idiomas: 516, Ingles solo usado por las clases altas