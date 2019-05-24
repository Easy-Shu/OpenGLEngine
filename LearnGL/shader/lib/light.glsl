#ifndef _LIGHT_
#define _LIGHT_

//#define _SpotLight_


/*
light cast material 
*/
struct Material
{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
};

/*
light inference config
*/
struct Light
{
    vec3 direction;
    vec3 color;
#ifdef  _SpotLight_
#define _PointLight_
    float cutOff;
    float outerCutOff;
#endif
    
#ifdef _PointLight_
    vec3 position;
    vec3 constant;
#endif
};


in vec3 worldPos;
in vec3 normal;
uniform vec3 viewPos;
uniform Light light;
uniform Material material;


vec3 Diffuse()
{
    vec3 norm = normalize(normal);
    vec3 lightDir = normalize(-light.direction);
#ifdef _PointLight_
    lightDir = normalize(light.position - worldPos);
#endif
    float diff = max(dot(norm, lightDir), 0.0f);
    return light.color * diff * material.diffuse;
}


vec3 Specular()
{
    vec3 norm = normalize(normal);
    vec3 lightDir = normalize(-light.direction);
    vec3 viewDir = normalize(viewPos - worldPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0f), material.shininess);
    return light.color * spec * material.specular;
}

vec3 Blinn_Specular()
{
    vec3 norm = normalize(normal);
    vec3 lightDir = normalize(-light.direction);
    vec3 viewDir = normalize(viewPos - worldPos);
    vec3 halfwayDir = normalize(lightDir + viewDir);
    float spec = pow(max(dot(normal, halfwayDir), 0.0), material.shininess);
    return light.color * spec * material.specular;
}


vec3 LightColor()
{
    vec3 ambient = vec3(0.8f) * material.ambient;
    vec3 diffuse = Diffuse();
    vec3 specular = Specular();

#ifdef  _SpotLight_
    lightDir = normalize(light.position - worldPos);
    float theta = dot(lightDir, normalize(-light.direction));
    float epsilon = (light.cutOff - light.outerCutOff);
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.25f, 1.0f);
#endif
    
#ifdef _PointLight_
    float distance =  length(light.position - worldPos);
    vec3 cst = light.constant;
    float atten = 1.0f/(cst.x+cst.y*distance+cst.z*distance*distance);
#endif

vec3 lightcolor = ambient + diffuse + specular;
    
#ifdef _PointLight_
    lightcolor = atten  * lightcolor;
#endif
    
#ifdef  _SpotLight_
    lightcolor *= intensity;
#endif

    return lightcolor;
}


#endif